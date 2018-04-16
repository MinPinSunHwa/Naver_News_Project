

#------------------------------------------------------------------
#                      ���̺귯�� �ҷ�����
#------------------------------------------------------------------
library(KoNLP)
library(stringr)
library(dplyr)



#------------------------------------------------------------------
#                        �ѱ� ���� ���
#------------------------------------------------------------------
# useSystemDic()
# useSejongDic()
useNIADic()



#------------------------------------------------------------------
#                        ������ �ҷ�����
#------------------------------------------------------------------
news <- read.csv("science_IT_data/2017_4Q.csv", stringsAsFactors=FALSE)
Contents <- news[,2]

# news <- read.csv("science_IT_data/2007_science_IT.csv", stringsAsFactors = FALSE)
# Title <- news[,2]



#------------------------------------------------------------------
#                        �ܾ� ���� �м�
#------------------------------------------------------------------
## extractNoun : �ܾ� ����
## SimplePos22 : �ܾ� ���� �м�
words <- sapply(Contents, SimplePos22, USE.NAMES = F)


# NC, F ���¸� ���� 
words_pre <- unlist(words)
words_pre <- str_match(words_pre, "([0-9a-zA-Z��-�R]+)/(NC|F)")


# NC, F ���� ���� ����
words_NC <- Filter(function(x) {!is.na(x)}, words_pre[,2])


# ������ ����
Q4_words <- words
save(Q4_words, file="science_IT_data/2017_4Q_words.RData")



#------------------------------------------------------------------
#                      ������ ��ó�� 2��
#------------------------------------------------------------------
# ���� �ǹ��� �ܾ� ����
words_NC <- toupper(words_NC)
words_NC <- gsub("��S","������S", words_NC)
words_NC <- gsub("(������S[0-9]).*","\\1", words_NC)
words_NC <- gsub("^(S[0-9]).*","������\\1", words_NC)
words_NC <- gsub("����Ʈ", "�����ó�Ʈ", words_NC)
words_NC <- gsub("(�����ó�Ʈ[0-9]).*","\\1", words_NC)
words_NC <- gsub("^(��Ʈ[0-9]).*","������\\1", words_NC)
words_NC <- gsub("(G[0-9]{1,2}).", "\\1", words_NC)
words_NC <- gsub("(V[0-9]{1,2}).", "\\1", words_NC)
words_NC <- gsub("(������[0-9]).", "\\1", words_NC)
words_NC <- gsub("����Ͽ�����׷���", "MWC", words_NC)
words_NC <- gsub("����", "NASA", words_NC)
words_NC <- gsub("������", "DNA", words_NC)
words_NC <- gsub("�޴���ȭ", "�޴���", words_NC)
words_NC <- gsub("������ű��", "ICT", words_NC)
words_NC <- gsub("DRONE", "���", words_NC)
words_NC <- gsub("���ҿ������", "LTE", words_NC)
words_NC <- gsub("��Ƽ��", "LTE", words_NC)
words_NC <- gsub("�����ͺ��̽�", "DB", words_NC)
words_NC <- gsub("4���������.", "4���������", words_NC)
words_NC <- gsub("���İ�.", "���İ�", words_NC)
words_NC <- gsub("�߻簡", "�߻�", words_NC)
words_NC <- gsub("MP3�÷��̾�", "MP3", words_NC)
words_NC <- gsub("������DMB", "DMB", words_NC)
words_NC <- gsub("���ڽŹ����ͳ�", "���ڽŹ�", words_NC)
words_NC <- gsub("�繰���ͳ�", "IOT", words_NC)
words_NC <- gsub("��������", "VR", words_NC)
words_NC <- gsub("��������", "AR", words_NC)
words_NC <- gsub("����߱����̿���", "OLED", words_NC)




# �ҿ�� ����
remove_list <- sort(remove_list, decreasing=T)
r <- length(remove_list)

for(i in 1:r){
  word <- remove_list[i]
  
  words_NC <- gsub(word,"", words_NC)
  words_NC <- Filter(function(x) {nchar(x) >= 1}, words_NC)
  cat(i,".",word,"remove.\n")
}

remove_list <- sort(names(table(remove_list)), decreasing=T)


# �󵵼� Ȯ��
words_freq <- table(words_NC)
words_freq <- sort(words_freq, decreasing=T)
words_freq <- words_freq[words_freq >= 300]
words_list <- names(words_freq)
words_list


#------------------------------------------------------------------
#                    �ҿ�� ����Ʈ �����
#------------------------------------------------------------------
# �ҿ�� �߰�
words_freq <- table(words_NC)
words_freq <- sort(words_freq, decreasing=T)
words_freq <- words_freq[words_freq >= 300]
words_list <- names(words_freq)
words_list
l <- length(words_list)

for(i in 1:l){
  word <- words_list[i]
  cat(i, ".", word, ": ")
  
  choose_mode <- readline(prompt="(1:remove 2:next *:break) :")
  
  if(choose_mode==1){
    choose_mode2 <- readline(prompt="(1:only *:every) : ")
    
    if(choose_mode2 == 1) {
      word <- paste("^", word,"$", sep="")
    }
    
    count <- length(remove_list) + 1
    remove_list[count] <- word
  }
  else if(choose_mode==2) next
  else break
}


# �ҿ�� ���� �Է�
words_freq <- table(words_NC)
words_freq <- sort(words_freq, decreasing=T)
words_freq <- words_freq[words_freq < 100]
words_list <- names(words_freq)

while(TRUE) {
  word <- readline(prompt="������ �ܾ� �Է� (\'�׸��Է�\' ������ ����) : ")
  
  if(word == '�׸��Է�') break
  
  count <- length(remove_list) + 1
  remove_list[count] <- word
  
  cat(word, "add remove list")
}


# �ҿ�� ����
write.table(remove_list, "science_IT_data/remove_list.txt", row.names=F)



#------------------------------------------------------------------
#                          ������ ����
#------------------------------------------------------------------
write.table(words_NC, "science_IT_data/2017/2017_1Q_words_NC.txt", row.names=F)
write.table(words_freq, "science_IT_data/2017/2017_1Q_contents_freq.txt", row.names=F)

# write.table(words_NC, "science_IT_data/2007/2007_title_words_NC.txt", row.names=F)
# write.table(words_freq, "science_IT_data/2007/2007_title_freq.txt", row.names=F)



#------------------------------------------------------------------
#                   �ӽ������� ������ �ҷ�����
#------------------------------------------------------------------
words_NC <- read.table("science_IT_data/2017/2017_1Q_words_NC.txt", 
                       header=T, stringsAsFactors=F)
words_NC <- unlist(words_NC)

remove_list <- read.table("science_IT_data/remove_list.txt", 
                          header=T, stringsAsFactors=F)
remove_list <- unlist(remove_list)



#------------------------------------------------------------------
#                             ����
#------------------------------------------------------------------
#http://webcache.googleusercontent.com/search?q=cache:QNl25hJ33r8J:www.kunsan.ac.kr/knuctl/board/download.kunsan%3FboardId%3DBBS_0000545%26menuCd%3DDOM_000003904002000000%26startPage%3D1%26dataSid%3D60717%26command%3Dupdate%26fileSid%3D19662+&cd=1&hl=ko&ct=clnk&gl=kr




rm(news)
rm(Contents)
rm(words)
rm(words_pre)
rm(words_NC)
rm(Q3_words)
rm(list=ls())