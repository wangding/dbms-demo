#!/usr/bin/env bash

showMenu() {
  clear
  echo -e "\t[1] 查看数据库"
  echo -e "\t[2] 查看 DBMS"
  echo -e "\t[3] 查看应用程序"
  echo -e "\t[0] 退出\n"
  echo -ne "\t请输入操作编号："; read menu
}

showMenu

while [ $menu -eq $menu ];
do
case $menu in
  1) # 查看数据库
    echo -e '\e[42m1) databases in dbms\n\e[49m'
    mysql -h 127.0.0.1 -u root -pddd -e "show databases;" 2>/dev/null
    echo -e '\e[42m\n2) the directories of database in /var/lib/mysql\n\e[49m'
    sudo ls /var/lib/mysql/ --color
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  2) # 查看 DBMS
    echo -e '\e[42m1) myslqd process info\e[49m\n'
    ps aux | grep mysql
    echo -e '\e[42m\n2) mysqld process status\n\e[49m'
    systemctl status mysqld
    echo -e '\e[42m\n3) mysqld apps in /usr/sbin\e[49m\n'
    sudo ls --color /usr/sbin/my*
    echo -n '按任意键继续...'; read
    showMenu
    ;;

  3) # 查看应用程序
    echo -e '\e[42m1) installed mysql packages\n\e[49m'
    yum list installed |grep mysql
    echo -e "\e[42m\n2) mysql's locations\n\e[49m"
    which mysql
    echo -e '\e[42m\n3) mysql apps in /usr/bin/\n\e[49m'
    sudo ls --color /usr/bin/my*
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
