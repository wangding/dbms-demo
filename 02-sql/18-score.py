import os
import mysql.connector

cnx = mysql.connector.connect(user='wangding', password='ddd', database='college')
cur = cnx.cursor(buffered=True)
courses = {
  "3": "c",
  "4": "python",
  "5": "ds"
}

def showMenu():
  os.system('clear')
  print("\t[1] 查询学生成绩")
  print("\t[2] 添加学生成绩")
  print("\t[3] 修改学生成绩")
  print("\t[4] 删除学生成绩")
  print("\t[0] 退出\n")
  menu = input("\t请输入操作编号：")

  return menu

def queryScores():
  no = input("\n请输入学生编号：")
  col = input("[3] c\n[4] python\n[5] ds\n请输入课程编号：")

  query = "select " + courses.get(col) + " from college.scores where id=" + no + ";"

  cur.execute(query)

  results = cur.fetchone()
  print(results)

  input("按任意键继续...")
  menu = showMenu()
  return menu

def addScore():
  print("\n输入格式：学号,\"姓名\",c-score,python-score,ds-score")
  row = input()
  query = "insert into college.scores values (" + row + ")"

  cur.execute(query)
  cnx.commit();

  input("按任意键继续...")
  menu = showMenu()
  return menu

def modifyScore():
  no = input("\n请输入学生编号：")
  col = input("[3] c\n[4] python\n[5] ds\n请输入课程编号：")
  score = input("请输入课程成绩：")

  query = "update college.scores set " + courses.get(col) + "=" + score + " where id=" + no + ";"
  cur.execute(query)
  cnx.commit()

  input("按任意键继续...")
  menu = showMenu()
  return menu

def deleteScore():
  no = input("\n请输入学生编号：")
  query = "delete from college.scores where id=" + no + ";"
  print(query)
  cur.execute(query)
  cnx.commit();

  input("按任意键继续...")
  menu = showMenu()
  return menu

menu = showMenu()
while True:
  if menu == "1":
    menu = queryScores()
  elif menu == "2":
    menu = addScore()
  elif menu == "3":
    menu = modifyScore()
  elif menu == "4":
    menu = deleteScore()
  elif menu == "0":
    cnx.close()
    exit()
  else:
    cnx.close()
    exit(int(menu))
