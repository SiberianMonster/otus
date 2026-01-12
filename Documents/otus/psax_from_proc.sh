#!/usr/bin/env bash
set -euo pipefail

# psax_from_proc.sh

CLK_TCK="$(getconf CLK_TCK 2>/dev/null || echo 100)"
BOOTTIME="$(awk '$1=="btime"{print $2}' /proc/stat)"
UPTIME="$(awk '{print $1}' /proc/uptime)"

fmt_time() { # seconds -> HH:MM:SS
  local s=$1 h m
  h=$((s/3600)); m=$(((s%3600)/60)); s=$((s%60))
  printf "%02d:%02d:%02d" "$h" "$m" "$s"
}

tty_from_fd0() { 
  local pid=$1 link tty
  link="$(readlink -f "/proc/$pid/fd/0" 2>/dev/null || true)"
  case "$link" in
    /dev/tty*)   tty="${link#/dev/}" ;;
    /dev/pts/*)  tty="pts/${link#/dev/pts/}" ;;
    *)           tty="?" ;;
  esac
  echo "$tty"
}

stat_char() { # STAT flags 
  local pid=$1 state flags sess tpgid tty_nr stat_file="/proc/$pid/stat"
  [[ -r "$stat_file" ]] || return 1

  # /proc/PID/stat парсила с awk 
  read -r state flags sess tty_nr tpgid < <(
    awk '
      {
        
        s = $0
        p = index(s, ")")
        rest = substr(s, p+2)         
        n = split(rest, a, " ")
        st = a[1]
        print st, a[4], a[5], a[6], a[7]
      }
    ' "$stat_file"
  )

  local stat="$state"

  if [[ "$tty_nr" != "0" && "$tpgid" != "-1" && "$tpgid" == "$pid" ]]; then
    stat="${stat}+"
  fi

  if [[ "$sess" == "$pid" ]]; then
    stat="${stat}s"
  fi

  local threads
  threads="$(awk '$1=="Threads:"{print $2}' "/proc/$pid/status" 2>/dev/null || echo 1)"
  if [[ "${threads:-1}" -gt 1 ]]; then
    stat="${stat}l"
  fi

  echo "$stat"
}

cpu_time_seconds() { 
  local pid=$1 stat_file="/proc/$pid/stat"
  [[ -r "$stat_file" ]] || return 1
  awk -v HZ="$CLK_TCK" '
    {
      s=$0
      p=index(s,")")
      rest=substr(s,p+2)
      n=split(rest,a," ")
      ut=a[12]; st=a[13]
      if (ut=="" || st=="") { print 0; exit }
      printf "%.0f\n", (ut+st)/HZ
    }
  ' "$stat_file"
}

command_line() { 
  local pid=$1 cmd
  cmd="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null | sed 's/[[:space:]]*$//')"
  if [[ -z "$cmd" ]]; then
    cmd="$(cat "/proc/$pid/comm" 2>/dev/null || echo "?")"
  fi
  echo "$cmd"
}

printf "%5s %-8s %-6s %8s %s\n" "PID" "TTY" "STAT" "TIME" "COMMAND"

for d in /proc/[0-9]*; do
  pid="${d#/proc/}"
  [[ -r "/proc/$pid/stat" ]] || continue

  tty="$(tty_from_fd0 "$pid")"
  stat="$(stat_char "$pid" 2>/dev/null || echo "?")"
  tsec="$(cpu_time_seconds "$pid" 2>/dev/null || echo 0)"
  time="$(fmt_time "${tsec:-0}")"
  cmd="$(command_line "$pid")"

  printf "%5d %-8s %-6s %8s %s\n" "$pid" "$tty" "$stat" "$time" "$cmd"
done | sort -n