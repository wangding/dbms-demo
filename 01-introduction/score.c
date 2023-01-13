#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char dataFile[] = "./scores.csv";

int printMenu() {
  int menu = 0;

  printf("\033[2;J\033[1;1;H");
  printf("\t[1] 查询学生成绩\n");
  printf("\t[2] 添加学生成绩\n");
  printf("\t[3] 修改学生成绩\n");
  printf("\t[4] 删除学生成绩\n");
  printf("\t[0] 退出\n");
  printf("\t请输入操作编号：");
  scanf("%d", &menu);

  return menu;
}

char** split(const char* str, const char* delimiter) {
  int i = 0;
  int capacity = 16;
  char* token;
  char* rest = strdup(str);
  char** fields = malloc(capacity * sizeof(char*));

  while ((token = strtok_r(rest, delimiter, &rest))) {
    if (i >= capacity) {
      capacity *= 2;
      fields = realloc(fields, capacity * sizeof(char*));
    }
    fields[i++] = strdup(token);
  }

  if (i >= capacity) {
    fields = realloc(fields, (i+1) * sizeof(char*));
  }
  fields[i] = NULL;
  return fields;
}


void query() {
  char no[20] = "";
  int col = 0;

  printf("\n请输入学生编号：");
  scanf("%s", no);
  printf("[3] c\n[4] python\n[5] ds\n请输入课程编号：");
  scanf("%d", &col);

  FILE* fp;
  char* line = NULL;
  size_t len = 0;
  ssize_t read;

  fp = fopen(dataFile, "r");
  if(fp == NULL) {
    printf("Error opening file: %s", dataFile);
    exit(1);
  }

  while((read = getline(&line, &len, fp)) != -1) {
    if(strstr(line, no) != NULL) break;
  }

  char** fields = split(line, ",");
  char score[10] = "";
  len = strlen(fields[col-1]);
  if(col==5) {
    strncpy(score, fields[col-1]+1, len-3);
  } else {
    strncpy(score, fields[col-1]+1, len-2);
  }
  printf("score: %s\n", score);

  free(line);
  free(fields);
  fclose(fp);
}

void append() {
  printf("\n输入格式：\"学号\",\"姓名\",\"c-score\",\"python-score\",\"ds-score\"\n");
  char data[256] = "";
  scanf("%s", data);

  FILE *fp;
  fp = fopen(dataFile, "a");
  fprintf(fp, "%s", data);
  fprintf(fp, "\n");
  fclose(fp);
}

void update() {
  char no[20] = "";
  int col = 0, score;

  printf("\n请输入学生编号：");
  scanf("%s", no);
  printf("[3] c\n[4] python\n[5] ds\n请输入课程编号：");
  scanf("%d", &col);
  printf("请输入课程成绩：");
  scanf("%d", &score);

  FILE *fp1, *fp2;
  char *line = NULL;
  size_t len = 0;
  size_t read = 0;

  fp1 = fopen(dataFile, "r");
  fp2 = fopen("./tmp.txt", "w");

  char** fields = NULL;

  while((read = getline(&line, &len, fp1)) != -1) {
    if(strstr(line, no) == NULL) {
      fprintf(fp2, "%s", line);
    } else {
      fields = split(line, ",");
      sprintf(fields[col-1], "\"%d\"", score);
      char message[100];
      sprintf(message, "%s,%s,%s,%s,%s", fields[0], fields[1], fields[2], fields[3], fields[4]);
      fprintf(fp2, "%s", message);
    }
  }

  fclose(fp1);
  fclose(fp2);

  remove(dataFile);
  rename("tmp.txt", dataFile);
  free(fields);
  free(line);
}

void delete() {
  char no[20] = "";
  printf("\n请输入学生编号：");
  scanf("%s", no);

  FILE *fp1, *fp2;
  char *line = NULL;
  size_t len = 0;
  size_t read = 0;

  fp1 = fopen(dataFile, "r");
  fp2 = fopen("./tmp.txt", "w");

  while((read = getline(&line, &len, fp1)) != -1) {
    if(strstr(line, no) == NULL) {
      fprintf(fp2, "%s", line);
    } else {
      fprintf(fp2, "%s", "");
    }
  }

  fclose(fp1);
  fclose(fp2);

  remove(dataFile);
  rename("tmp.txt", dataFile);
}

int main(void) {
  int menu = 0;

  for(;;) {
    menu = printMenu();
    switch (menu) {
      case 1:
        query();
        break;

      case 2:
        append();
        break;

      case 3:
        update();
        break;

      case 4:
        delete();
        break;

      case 0:
        exit(0);
        break;

      default:
        exit(menu);
    }
    printf("请按任意键继续...");
    getchar();
    getchar();
  }
}
