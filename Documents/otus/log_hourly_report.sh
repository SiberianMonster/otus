#!/usr/bin/env bash
# log_hourly_report.sh
# Каждый час отправляет письмо с отчетом по логам 
# Использованы: traps, functions, sed, find, cron, lock 
# Не тестировала с внешним SMTP, локально письмо было сгенерировано

set -euo pipefail

### ---- CONFIG ----
TO_EMAIL="${TO_EMAIL:-root}"                               
FROM_EMAIL="${FROM_EMAIL:-alerts@example.com}"            
FROM_NAME="${FROM_NAME:-Log Reporter}"
MAIL_SUBJECT_PREFIX="${MAIL_SUBJECT_PREFIX:-Web log report}"

LOG_FILE="${LOG_FILE:-/var/log/access-4560-644067.log}"   

STATE_DIR="${STATE_DIR:-/var/tmp/log_hourly_report}"
LOCK_FILE="${LOCK_FILE:-$STATE_DIR/log_hourly_report.lock}"

TOP_N="${TOP_N:-20}"
ERROR_TAIL_LINES="${ERROR_TAIL_LINES:-200}"                

MAIL_BIN="${MAIL_BIN:-/usr/bin/mail}"                      
SENDMAIL_FALLBACK="${SENDMAIL_FALLBACK:-/usr/sbin/sendmail}"

umask 077

### ---- ФУНКЦИИ ----
log() { printf '%s %s\n' "$(date -Is)" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

cleanup() {
  [[ -n "${TMPDIR_RUN:-}" && -d "${TMPDIR_RUN:-}" ]] && rm -rf "${TMPDIR_RUN:-}"
}
trap cleanup EXIT INT TERM

ensure_deps() {
  command -v awk >/dev/null || die "awk not found"
  command -v sed >/dev/null || die "sed not found"
  command -v sort >/dev/null || die "sort not found"
  command -v head >/dev/null || die "head not found"
  command -v tail >/dev/null || die "tail not found"
  command -v wc >/dev/null || die "wc not found"
  command -v flock >/dev/null || die "flock not found (util-linux)"
}

# Предотвращает одновременный запуск нескольких копий
acquire_lock() {
  mkdir -p "$STATE_DIR"
  exec 9>"$LOCK_FILE"
  if ! flock -n 9; then
    log "Another instance is running; exiting."
    exit 0
  fi
}

init_state() {
  mkdir -p "$STATE_DIR"

  # Находит и удаляет файлы старше 7 дней.
  find "$STATE_DIR" -type f -name '*.state' -mtime +7 -print -delete >/dev/null 2>&1 || true

  LAST_POS_FILE="$STATE_DIR/last_pos.state"
  LAST_TIME_FILE="$STATE_DIR/last_time.state"

  [[ -f "$LAST_POS_FILE" ]] || echo "0" >"$LAST_POS_FILE"
  [[ -f "$LAST_TIME_FILE" ]] || date -Is >"$LAST_TIME_FILE"
}


extract_time_brackets() {
  sed -n 's/^[^[]*\[\([^]]*\)\].*$/\1/p'
}

read_incremental_lines() {
  local last_pos size start
  last_pos="$(<"$LAST_POS_FILE")"
  size="$(wc -c <"$LOG_FILE")"

  if [[ "$size" -lt "$last_pos" ]]; then
    last_pos=0
  fi

  start=$(( last_pos + 1 ))
  if [[ "$start" -le "$size" ]]; then
    tail -c +"$start" "$LOG_FILE"
  fi
}

send_email() {
  local subject="$1" body_file="$2"

  if [[ -x "$SENDMAIL_FALLBACK" ]]; then
    {
      echo "To: $TO_EMAIL"
      echo "From: ${FROM_NAME} <${FROM_EMAIL}>"
      echo "Subject: $subject"
      echo "Date: $(LC_ALL=C date -R)"
      echo "MIME-Version: 1.0"
      echo "Content-Type: text/plain; charset=UTF-8"
      echo "Content-Transfer-Encoding: 8bit"
      echo
      cat "$body_file"
    } | "$SENDMAIL_FALLBACK" -t || die "sendmail failed"
    return 0
  fi

  # Fallback to mail/mailx if sendmail isn't present
  if [[ -x "$MAIL_BIN" ]]; then

    if "$MAIL_BIN" -s "$subject" -r "$FROM_EMAIL" "$TO_EMAIL" <"$body_file" 2>/dev/null; then
      return 0
    fi
    if "$MAIL_BIN" -s "$subject" -a "From: ${FROM_NAME} <${FROM_EMAIL}>" "$TO_EMAIL" <"$body_file" 2>/dev/null; then
      return 0
    fi
    "$MAIL_BIN" -s "$subject" "$TO_EMAIL" <"$body_file" || die "mail command failed"
    return 0
  fi

  die "No mailer found. Install mailx/mailutils or provide SENDMAIL_FALLBACK."
}

analyze_lines() {
  local input_file="$1" out_file="$2"

  if [[ ! -s "$input_file" ]]; then
    echo "No new log lines since last run." >"$out_file"
    return 0
  fi

  local first_ts last_ts
  # Временной диапазон
  first_ts="$(head -n 1 "$input_file" | extract_time_brackets)"
  last_ts="$(tail -n 1 "$input_file" | extract_time_brackets)"

  # Временные файлы для счета
  local ip_counts_file url_counts_file code_counts_file
  ip_counts_file="$TMPDIR_RUN/ip_counts.txt"
  url_counts_file="$TMPDIR_RUN/url_counts.txt"
  code_counts_file="$TMPDIR_RUN/code_counts.txt"

  : >"$ip_counts_file"
  : >"$url_counts_file"
  : >"$code_counts_file"

  # Парсинг
  awk -v ERROR_TAIL="$ERROR_TAIL_LINES" \
      -v IP_OUT="$ip_counts_file" \
      -v URL_OUT="$url_counts_file" \
      -v CODE_OUT="$code_counts_file" '
    {
      line = $0

      # Список IP адресов
      if (match(line, /^([0-9]{1,3}\.){3}[0-9]{1,3}/)) {
        ip = substr(line, RSTART, RLENGTH)
        ip_count[ip]++
      }

      # Список запрашиваемых URL
      if (match(line, /"[A-Z]+[[:space:]]+([^[:space:]]+)[[:space:]]+HTTP\/[0-9.]+"/, m)) {
        url = m[1]
        url_count[url]++
      }

      # Список всех кодов HTTP ответа
      if (match(line, /HTTP\/[0-9.]+"[[:space:]]+([0-9]{3})[[:space:]]+/, s)) {
        code = s[1]
        code_count[code]++

        # Ошибки веб-сервера/приложения c момента последнего запуска
        if (code ~ /^5[0-9][0-9]$/ || (code ~ /^4[0-9][0-9]$/ && code != "404")) {
          err_lines[++err_n] = line
        }
      }

      if (tolower(line) ~ /(error|exception|traceback|fatal)/) {
        kw_err_lines[++kw_err_n] = line
      }
    }

    END {
      # Write count files for shell sorting
      for (k in ip_count)  print ip_count[k], k > IP_OUT
      close(IP_OUT)

      for (u in url_count) print url_count[u], u > URL_OUT
      close(URL_OUT)

      for (c in code_count) print code_count[c], c > CODE_OUT
      close(CODE_OUT)

      print "== Web server / application errors (5xx + 4xx except 404) =="
      if (err_n == 0) print "None detected by status-code rule."
      else {
        start = (err_n > ERROR_TAIL ? err_n - ERROR_TAIL + 1 : 1)
        for (i = start; i <= err_n; i++) print err_lines[i]
      }

      print ""
      print "== Keyword error matches (error/exception/traceback/fatal) =="
      if (kw_err_n == 0) print "None."
      else {
        start2 = (kw_err_n > ERROR_TAIL ? kw_err_n - ERROR_TAIL + 1 : 1)
        for (j = start2; j <= kw_err_n; j++) print kw_err_lines[j]
      }
    }
  ' "$input_file" >"$out_file.tmp"

  {
    echo "Web Log Hourly Report"
    echo "Processed time range:"
    echo "  From: [$first_ts]"
    echo "  To:   [$last_ts]"
    echo "Log file: $LOG_FILE"
    echo

    echo "== Top IPs by request count (since last run) =="
    if [[ -s "$ip_counts_file" ]]; then
      sort -nr "$ip_counts_file" | head -n "$TOP_N" | sed 's/^/  /'
    else
      echo "  (no data)"
    fi
    echo

    echo "== Top requested URLs by request count (since last run) =="
    if [[ -s "$url_counts_file" ]]; then
      sort -nr "$url_counts_file" | head -n "$TOP_N" | sed 's/^/  /'
    else
      echo "  (no data)"
    fi
    echo

    echo "== HTTP response codes and counts (since last run) =="
    if [[ -s "$code_counts_file" ]]; then
      sort -nr "$code_counts_file" | sed 's/^/  /'
    else
      echo "  (no data)"
    fi
    echo

    sed -n '/== Web server \/ application errors/,/^== Keyword error matches/{
      /^== Keyword error matches/!p
    }' "$out_file.tmp" | sed 's/^/  /'
    echo
    sed -n '/^== Keyword error matches/,$p' "$out_file.tmp" | sed 's/^/  /'
  } >"$out_file"

  rm -f "$out_file.tmp"
}

main() {
  ensure_deps
  [[ -r "$LOG_FILE" ]] || die "Cannot read LOG_FILE: $LOG_FILE"

  acquire_lock
  init_state

  TMPDIR_RUN="$(mktemp -d "$STATE_DIR/run.XXXXXX")"
  local input_file="$TMPDIR_RUN/new_lines.log"
  local report_file="$TMPDIR_RUN/report.txt"

  read_incremental_lines >"$input_file" || true

  analyze_lines "$input_file" "$report_file"

  local size
  size="$(wc -c <"$LOG_FILE")"
  echo "$size" >"$LAST_POS_FILE"
  date -Is >"$LAST_TIME_FILE"

  local subject="${MAIL_SUBJECT_PREFIX} - $(hostname -s) - $(date '+%Y-%m-%d %H:%M %Z')"
  send_email "$subject" "$report_file"
}

main "$@"
