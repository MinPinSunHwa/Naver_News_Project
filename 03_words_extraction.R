

#------------------------------------------------------------------
#                      라이브러리 불러오기
#------------------------------------------------------------------
library(KoNLP)
library(stringr)
library(dplyr)



#------------------------------------------------------------------
#                        한글 사전 사용
#------------------------------------------------------------------
# useSystemDic()
# useSejongDic()
useNIADic()



#------------------------------------------------------------------
#                        데이터 불러오기
#------------------------------------------------------------------
news <- read.csv("science_IT_data/2017_4Q.csv", stringsAsFactors=FALSE)
Contents <- news[,2]

# news <- read.csv("science_IT_data/2007_science_IT.csv", stringsAsFactors = FALSE)
# Title <- news[,2]



#------------------------------------------------------------------
#                        단어 형태 분석
#------------------------------------------------------------------
## extractNoun : 단어 추출
## SimplePos22 : 단어 형태 분석
words <- sapply(Contents, SimplePos22, USE.NAMES = F)


# NC, F 형태만 추출 
words_pre <- unlist(words)
words_pre <- str_match(words_pre, "([0-9a-zA-Z가-힣]+)/(NC|F)")


# NC, F 외의 형태 제거
words_NC <- Filter(function(x) {!is.na(x)}, words_pre[,2])


# 데이터 저장
Q4_words <- words
save(Q4_words, file="science_IT_data/2017_4Q_words.RData")



#------------------------------------------------------------------
#                      데이터 전처리 2차
#------------------------------------------------------------------
# 같은 의미의 단어 통일
words_NC <- toupper(words_NC)
words_NC <- gsub("갤S","갤럭시S", words_NC)
words_NC <- gsub("(갤럭시S[0-9]).*","\\1", words_NC)
words_NC <- gsub("^(S[0-9]).*","갤럭시\\1", words_NC)
words_NC <- gsub("갤노트", "갤럭시노트", words_NC)
words_NC <- gsub("(갤럭시노트[0-9]).*","\\1", words_NC)
words_NC <- gsub("^(노트[0-9]).*","갤럭시\\1", words_NC)
words_NC <- gsub("(G[0-9]{1,2}).", "\\1", words_NC)
words_NC <- gsub("(V[0-9]{1,2}).", "\\1", words_NC)
words_NC <- gsub("(아이폰[0-9]).", "\\1", words_NC)
words_NC <- gsub("모바일월드콩그레스", "MWC", words_NC)
words_NC <- gsub("나사", "NASA", words_NC)
words_NC <- gsub("유전자", "DNA", words_NC)
words_NC <- gsub("휴대전화", "휴대폰", words_NC)
words_NC <- gsub("정보통신기술", "ICT", words_NC)
words_NC <- gsub("DRONE", "드론", words_NC)
words_NC <- gsub("롱텀에볼루션", "LTE", words_NC)
words_NC <- gsub("엘티이", "LTE", words_NC)
words_NC <- gsub("데이터베이스", "DB", words_NC)
words_NC <- gsub("4차산업혁명.", "4차산업혁명", words_NC)
words_NC <- gsub("알파고.", "알파고", words_NC)
words_NC <- gsub("발사가", "발사", words_NC)
words_NC <- gsub("MP3플레이어", "MP3", words_NC)
words_NC <- gsub("지상파DMB", "DMB", words_NC)
words_NC <- gsub("전자신문인터넷", "전자신문", words_NC)
words_NC <- gsub("사물인터넷", "IOT", words_NC)
words_NC <- gsub("가상현실", "VR", words_NC)
words_NC <- gsub("증강현실", "AR", words_NC)
words_NC <- gsub("유기발광다이오드", "OLED", words_NC)




# 불용어 제거
remove_list <- sort(remove_list, decreasing=T)
r <- length(remove_list)

for(i in 1:r){
  word <- remove_list[i]
  
  words_NC <- gsub(word,"", words_NC)
  words_NC <- Filter(function(x) {nchar(x) >= 1}, words_NC)
  cat(i,".",word,"remove.\n")
}

remove_list <- sort(names(table(remove_list)), decreasing=T)


# 빈도수 확인
words_freq <- table(words_NC)
words_freq <- sort(words_freq, decreasing=T)
words_freq <- words_freq[words_freq >= 300]
words_list <- names(words_freq)
words_list


#------------------------------------------------------------------
#                    불용어 리스트 만들기
#------------------------------------------------------------------
# 불용어 추가
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


# 불용어 직접 입력
words_freq <- table(words_NC)
words_freq <- sort(words_freq, decreasing=T)
words_freq <- words_freq[words_freq < 100]
words_list <- names(words_freq)

while(TRUE) {
  word <- readline(prompt="제거할 단어 입력 (\'그만입력\' 누르면 종료) : ")
  
  if(word == '그만입력') break
  
  count <- length(remove_list) + 1
  remove_list[count] <- word
  
  cat(word, "add remove list")
}


# 불용어 저장
write.table(remove_list, "science_IT_data/remove_list.txt", row.names=F)



#------------------------------------------------------------------
#                          데이터 저장
#------------------------------------------------------------------
write.table(words_NC, "science_IT_data/2017/2017_1Q_words_NC.txt", row.names=F)
write.table(words_freq, "science_IT_data/2017/2017_1Q_contents_freq.txt", row.names=F)

# write.table(words_NC, "science_IT_data/2007/2007_title_words_NC.txt", row.names=F)
# write.table(words_freq, "science_IT_data/2007/2007_title_freq.txt", row.names=F)



#------------------------------------------------------------------
#                   임시저장한 데이터 불러오기
#------------------------------------------------------------------
words_NC <- read.table("science_IT_data/2017/2017_1Q_words_NC.txt", 
                       header=T, stringsAsFactors=F)
words_NC <- unlist(words_NC)

remove_list <- read.table("science_IT_data/remove_list.txt", 
                          header=T, stringsAsFactors=F)
remove_list <- unlist(remove_list)



#------------------------------------------------------------------
#                             참고
#------------------------------------------------------------------
#http://webcache.googleusercontent.com/search?q=cache:QNl25hJ33r8J:www.kunsan.ac.kr/knuctl/board/download.kunsan%3FboardId%3DBBS_0000545%26menuCd%3DDOM_000003904002000000%26startPage%3D1%26dataSid%3D60717%26command%3Dupdate%26fileSid%3D19662+&cd=1&hl=ko&ct=clnk&gl=kr




rm(news)
rm(Contents)
rm(words)
rm(words_pre)
rm(words_NC)
rm(Q3_words)
rm(list=ls())
