#!/bin/bash

# imported

function timer_now {
  date +%s%N
}

function timer_start {
  timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {

  if [ "$timer_start" = "" ]; then
    return
  fi

  local delta_us=$((($(timer_now) - $timer_start) / 1000))
  local us=$((delta_us % 1000))
  local ms=$(((delta_us / 1000) % 1000))
  local s=$(((delta_us / 1000000) % 60))
  local m=$(((delta_us / 60000000) % 60))
  local h=$((delta_us / 3600000000))
  # Goal: always show around 3 digits of accuracy
  if ((h > 0)); then
    timer_show=${h}h${m}m
  elif ((m > 0)); then
    timer_show=${m}m${s}s
  elif ((s >= 10)); then
    timer_show=${s}.$((ms / 100))s
  elif ((s > 0)); then
    timer_show=${s}.$(printf %03d "$ms")s
  elif ((ms >= 100)); then
    timer_show=${ms}ms
  elif ((ms > 0)); then
    timer_show=${ms}.$((us / 100))ms
  else
    timer_show=${us}us
  fi
  unset timer_start
}

trap 'timer_start' DEBUG

# parameters

# foregrounds
black_fg="30"
red_fg="31"
green_fg="32"
yellow_fg="33"
blue_fg="34"
purple_fg="35"
cyan_fg="36"
light_gray_fg="37"
gray_fg="90"
light_red_fg="91"
light_green_fg="92"
light_yellow_fg="93"
light_blue_fg="94"
light_purple_fg="95"
light_cyan_fg="96"
white_fg="97"

# backgrounds
black_bg="40"
red_bg="41"
green_bg="42"
yellow_bg="43"
blue_bg="44"
purple_bg="45"
cyan_bg="46"
light_gray_bg="47"
gray_bg="100"
light_red_bg="101"
light_green_bg="102"
light_yellow_bg="103"
light_blue_bg="104"
light_purple_bg="105"
light_cyan_bg="106"
white_bg="107"

# start / end
start_start="\[\033[0;"
start_end="m\]"
end="\[\033[m\]"

# icons
sep=
rsep=

sep1=
isep1=
rsep1=
irsep1=

# sep1=
# isep1=
# rsep1=
# irsep1=

upper_line_start=┌─
lower_line_start=└─
icon_timer1=󰔛
icon_timer2=󰚭
icon_v=
icon_x=
thumb_up=
thumb_down=
icon_git_branch=
icon_plus=
icon_clock_0=󱑊
icon_clock_6=󱑄
icon_location=
icon_terminal=
icon_arch_arrow=
icon_tux=
icon_profile=
icon_nix=󱄅
icon_dir_closed=
icon_locked=
icon_dir_opened=
icon_unlocked=
yazi_icon=

# battery
icon_bat_norm=󰁹
icon_bat_charge=󰂄
icon_bat_crit=󰂃
icon_bat_none=󰂑

icon_bat_0=󰂎
icon_bat_10=󰁺
icon_bat_20=󰁻
icon_bat_30=󰁼
icon_bat_40=󰁽
icon_bat_50=󰁾
icon_bat_60=󰁿
icon_bat_70=󰂀
icon_bat_80=󰂁
icon_bat_90=󰂂
icon_bat_100=󰁹

# wifi
icon_globe=
icon_wifi=
icon_wifi_sec=󱚿
icon_no_wifi=󰖪

# main

create_prompt() {

  timer_stop

  local right_text
  right_text="$(right)"

  local stripped
  stripped=$(printf '%s' "$right_text" | sed $'s/\x01//g; s/\x02//g; s\/x1b\\[[0-9;]]*m//g; s/\\\\[][]//g')
  local padding=$((COLUMNS - ${#stripped}))
  if ((padding < 0)); then padding=0; fi

  PS1=$(printf "\n%*s%s\n\n\r%s " "$padding" "" "$right_text" "$(left)")

}

right() {

  # duration (lightgray)

  dur="${start_start%?}${black_fg}${start_end}"
  dur="${dur}${rsep}${end}"
  dur="${dur}${start_start}${light_gray_fg};${black_bg}${start_end}"
  dur="${dur}${timer_show} ${end}"
  dur="${dur}${start_start}${black_fg};${light_gray_bg}${start_end}"
  dur="${dur} ${icon_timer1}${end}"
  dur="${dur}${start_start%?}${light_gray_fg}${start_end}"
  dur="${dur}${sep}${end}"

  # error code (green / red)

  if [[ $exit_code == 0 ]]; then
    err="${start_start%?}${black_fg}${start_end}"
    err="${err}${rsep}${end}"
    err="${err}${start_start}${green_fg};${black_bg}${start_end}"
    err="${err}${exit_code} ${end}"
    err="${err}${start_start}${black_fg};${green_bg}${start_end}"
    err="${err} ${thumb_up}${end}"
    err="${err}${start_start%?}${green_fg}${start_end}"
    err="${err}${sep}${end}"
  else
    err="${start_start%?}${black_fg}${start_end}"
    err="${err}${rsep}${end}"
    err="${err}${start_start}${red_fg};${black_bg}${start_end}"
    err="${err}${exit_code} ${end}"
    err="${err}${start_start}${black_fg};${red_bg}${start_end}"
    err="${err} ${thumb_down}${end}"
    err="${err}${start_start%?}${red_fg}${start_end}"
    err="${err}${sep}${end}"
  fi

  # git (cyan)

  # check if git
  git rev-parse --is-inside-work-tree &>/dev/null
  if [ $? -eq 0 ]; then

    is_git=" ${start_start%?}${black_fg}${start_end}"
    is_git="${is_git}${rsep}${end}"
    is_git="${is_git}${start_start}${cyan_fg};${black_bg}${start_end}"
    #
    # check if there are modified files
    if ! git diff-files --quiet 2>/dev/null || ! git diff-index --quiet --cached HEAD 2>/dev/null; then
      is_git="${is_git}${icon_plus} ${end}"
    else
      is_git="${is_git} ${end}"
    fi

    is_git="${is_git}${start_start}${black_fg};${cyan_bg}${start_end}"
    is_git="${is_git} ${icon_git_branch}${end}"
    is_git="${is_git}${start_start%?}${cyan_fg}${start_end}"
    is_git="${is_git}${sep}${end}"

  fi

  # battery (yellow / red)

  # check if the battery directory exists
  if [ -d /sys/class/power_supply/BAT0 ]; then
    bat_perc=$(cat /sys/class/power_supply/BAT0/capacity)
    bat_stat="$(cat /sys/class/power_supply/BAT0/status)"

    # battery percent
    if [ "$bat_perc" -lt 30 ]; then
      bat_fg=${red_fg}
      bat_bg=${red_bg}
    else
      bat_fg=${yellow_fg}
      bat_bg=${yellow_bg}
    fi

    # battery status
    if [ "$bat_stat" == "Charging" ]; then
      icon_bat="$icon_bat_charge"
      bat_fg=${yellow_fg}
      bat_bg=${yellow_bg}
    elif [ "$bat_perc" -lt 20 ]; then
      icon_bat="$icon_bat_crit"
    else
      # battery percent
      if [ "$bat_perc" -eq 0 ]; then
        icon_bat="$icon_bat_0"
      elif [ "$bat_perc" -lt 10 ]; then
        icon_bat="$icon_bat_10"
      elif [ "$bat_perc" -lt 20 ]; then
        icon_bat="$icon_bat_20"
      elif [ "$bat_perc" -lt 30 ]; then
        icon_bat="$icon_bat_30"
      elif [ "$bat_perc" -lt 40 ]; then
        icon_bat="$icon_bat_40"
      elif [ "$bat_perc" -lt 50 ]; then
        icon_bat="$icon_bat_50"
      elif [ "$bat_perc" -lt 60 ]; then
        icon_bat="$icon_bat_60"
      elif [ "$bat_perc" -lt 70 ]; then
        icon_bat="$icon_bat_70"
      elif [ "$bat_perc" -lt 80 ]; then
        icon_bat="$icon_bat_80"
      elif [ "$bat_perc" -lt 90 ]; then
        icon_bat="$icon_bat_90"
      else
        icon_bat="$icon_bat_100"
      fi
    fi

    bat="${start_start%?}${black_fg}${start_end}"
    bat="${bat}${rsep}${end}"
    bat="${bat}${start_start}${bat_fg};${black_bg}${start_end}"
    bat="${bat}${bat_perc}% ${end}"
    bat="${bat}${start_start}${black_fg};${bat_bg}${start_end}"
    bat="${bat} ${icon_bat}${end}"
    bat="${bat}${start_start%?}${bat_fg}${start_end}"
    bat="${bat}${sep}${end}"
  else
    icon_bat="$icon_bat_none"

    bat="${start_start%?}${black_fg}${start_end}"
    bat="${bat}${rsep}${end}"
    bat="${bat}${start_start}${yellow_fg};${black_bg}${start_end}"
    bat="${bat} ${end}"
    bat="${bat}${start_start}${black_fg};${yellow_bg}${start_end}"
    bat="${bat} ${icon_bat}${end}"
    bat="${bat}${start_start%?}${yellow_fg}${start_end}"
    bat="${bat}${sep}${end}"
  fi

  if [ "$YAZI_LEVEL" != "" ]; then
    yazi=" ${start_start%?}${black_fg}${start_end}"
    yazi="${yazi}${rsep}${end}"
    yazi="${yazi}${start_start}${cyan_fg};${black_bg}${start_end}"
    yazi="${yazi}YAZI ${end}"
    yazi="${yazi}${start_start}${black_fg};${cyan_bg}${start_end}"
    yazi="${yazi} ${yazi_icon}${end}"
    yazi="${yazi}${start_start%?}${cyan_fg}${start_end}"
    yazi="${yazi}${sep}${end}"
  fi

  echo -e "${err}${is_git} ${bat} ${dur}${yazi}"
}

left() {

  curr_time=$(date +%T)

  # time (purple)

  time="${start_start%?}${purple_fg}${start_end}"
  time="${time}${rsep}${end}"
  time="${time}${start_start}${black_fg};${purple_bg}${start_end}"
  time="${time}${icon_clock_0} ${end}"
  time="${time}${start_start}${purple_fg};${black_bg}${start_end}"
  time="${time} ${curr_time}${end}"
  time="${time}${start_start%?}${black_fg}${start_end}"
  time="${time}${sep}${end}"

  # user (blue)

  user="${start_start%?}${blue_fg}${start_end}"
  user="${user}${rsep}${end}"
  user="${user}${start_start}${black_fg};${blue_bg}${start_end}"
  user="${user}${icon_tux} ${end}"
  user="${user}${start_start}${blue_fg};${black_bg}${start_end}"
  user="${user} \u${end}"
  user="${user}${start_start%?}${black_fg}${start_end}"
  user="${user}${sep}${end}"

  # host (cyan)

  host="${start_start%?}${cyan_fg}${start_end}"
  host="${host}${rsep}${end}"
  host="${host}${start_start}${black_fg};${cyan_bg}${start_end}"
  host="${host}${icon_nix} ${end}"
  host="${host}${start_start}${cyan_fg};${black_bg}${start_end}"
  host="${host} \h${end}"
  host="${host}${start_start%?}${black_fg}${start_end}"
  host="${host}${sep}${end}"

  # dir (white / red)

  # check if write enabled
  if [[ ! -w "$PWD" ]]; then
    dir="${start_start%?}${red_fg}${start_end}"
    dir="${dir}${rsep}${end}"
    dir="${dir}${start_start}${black_fg};${red_bg}${start_end}"
    dir="${dir}${icon_dir_closed} ${end}"
    dir="${dir}${start_start}${red_fg};${black_bg}${start_end}"
    dir="${dir} \w${end}"
    dir="${dir}${start_start%?}${black_fg}${start_end}"
    dir="${dir}${sep}${end}"
  else
    dir="${start_start%?}${white_fg}${start_end}"
    dir="${dir}${rsep}${end}"
    dir="${dir}${start_start}${black_fg};${white_bg}${start_end}"
    dir="${dir}${icon_dir_opened} ${end}"
    dir="${dir}${start_start}${white_fg};${black_bg}${start_end}"
    dir="${dir} \w${end}"
    dir="${dir}${start_start%?}${black_fg}${start_end}"
    dir="${dir}${sep}${end}"
  fi

  # session (lightgray / red)

  if [[ $EUID == 0 ]]; then
    su_ps1="${start_start%?}${red_fg}${start_end}"
    su_ps1="${su_ps1}${rsep}${end}"
    su_ps1="${su_ps1}${start_start}${black_fg};${red_bg}${start_end}"
    su_ps1="${su_ps1}${icon_terminal} ${end}"
    su_ps1="${su_ps1}${start_start}${red_fg};${black_bg}${start_end}"
    su_ps1="${su_ps1} \\$"
    su_ps1="${su_ps1}${end}"
    su_ps1="${su_ps1}${start_start%?}${black_fg}${start_end}"
    su_ps1="${su_ps1}${sep}${end}"
  else
    su_ps1="${start_start%?}${light_gray_fg}${start_end}"
    su_ps1="${su_ps1}${rsep}${end}"
    su_ps1="${su_ps1}${start_start}${black_fg};${light_gray_bg}${start_end}"
    su_ps1="${su_ps1}${icon_terminal} ${end}"
    su_ps1="${su_ps1}${start_start}${light_gray_fg};${black_bg}${start_end}"
    su_ps1="${su_ps1} \\$"
    su_ps1="${su_ps1}${end}"
    su_ps1="${su_ps1}${start_start%?}${black_fg}${start_end}"
    su_ps1="${su_ps1}${sep}${end}"
  fi

  echo -e "${blank}${time} ${user} ${host} ${dir} \n${su_ps1}"

}

# PROMPT_COMMAND='create_prompt'
PROMPT_COMMAND='exit_code=$?; timer_start; trap "timer_stop" RETURN; create_prompt'
