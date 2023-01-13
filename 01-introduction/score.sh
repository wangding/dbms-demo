#!/usr/bin/env bash

showMenu() {
  clear
  echo -e "\t[1] 查询学生成绩"
  echo -e "\t[2] 添加学生成绩"
  echo -e "\t[3] 修改学生成绩"
  echo -e "\t[4] 删除学生成绩"
  echo -e "\t[0] 退出\n"
  echo -ne "\t请输入操作编号："; read menu
}

showMenu

while [ $menu -eq $menu ];
do
case $menu in
  1) # 查询学生成绩
    echo -ne "\n请输入学生编号："; read no
    echo -ne '[3] c\n[4] python\n[5] ds\n请输入课程编号：'; read col
    grep $no scores.csv | sed 's/\"//g' | awk -F ',' -v n=$col '{print $n}' | xargs -I{} echo 'score:' {}
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  2) # 添加学生成绩
    echo -e "\n输入格式：\"学号\",\"姓名\",\"c-score\",\"python-score\",\"ds-score\""
    read row
    echo $row >> scores.csv
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  3) # 修改学生成绩
    echo -ne "\n请输入学生编号："; read no
    echo -ne '[3] c\n[4] python\n[5] ds\n请输入课程编号：'; read col
    echo -ne '请输入课程成绩：'; read score
    old=$(grep $no scores.csv)
    new=$(grep $no scores.csv | sed 's/"//g' | awk -F ',' -v n=$col -v s=$score '{$n = s}{print}')
    new=$(echo $new | sed 's/ /","/g' | sed 's/^/"/g' | sed 's/$/"/g')
    sed -i "s/$old/$new/g" scores.csv
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  4) # 删除学生成绩
    echo -ne "\n请输入学生编号："; read no
    sed -i -e "/^\"$no/d" scores.csv
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  0) # 退出系统，正常退出，退出码为 0
    exit
    ;;

  *) # 输入不合法，异常退出，退出码为 $menu
    exit $menu
    ;;
esac
done
