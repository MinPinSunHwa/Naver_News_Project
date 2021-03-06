

#------------------------------------------------------------------
#                      라이브러리 불러오기
#------------------------------------------------------------------
library(stringr)
library(dplyr)



#------------------------------------------------------------------
#                        데이터 불러오기
#------------------------------------------------------------------
load("science_IT_data/2017_4Q_words.RData")



#------------------------------------------------------------------
#               list 형태로 NC, F 형태만 추출
#------------------------------------------------------------------
# NC, F 형태만 추출 
words_pre <- sapply(Q4_words, function(x) str_match(x, "([0-9a-zA-Z가-힣]+)/(NC|F)"))


# 형태 분석 못한 행 걸러내기
c <- c()
for (i in 1:length(words_pre)) {
  words <- words_pre[[i]]
  tryCatch(w <- words[,2],
           error=function(e) {
             c[length(c)+1] <<- i
             message(e)
           })
}
words_pre <- words_pre[-c]


# NC, F 외의 형태 제거
words_NC <- sapply(words_pre, function(x) Filter(function(y) !is.na(y), x[,2]))



#------------------------------------------------------------------
#                     같은 의미의 단어 통일
#------------------------------------------------------------------
words_NC <- sapply(words_NC, toupper)
words_NC <- sapply(words_NC, function(x) gsub("갤S","갤럭시S", x))
words_NC <- sapply(words_NC, function(x) gsub("(갤럭시S[0-9]).*","\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("^(S[0-9]).*","갤럭시\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("갤노트", "갤럭시노트", x))
words_NC <- sapply(words_NC, function(x) gsub("(갤럭시노트[0-9]).*","\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("^(노트[0-9]).*","갤럭시\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("(G[0-9]{1,2}).", "\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("(V[0-9]{1,2}).", "\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("(아이폰[0-9]).", "\\1", x))
words_NC <- sapply(words_NC, function(x) gsub("모바일월드콩그레스", "MWC", x))
words_NC <- sapply(words_NC, function(x) gsub("나사", "NASA", x))
words_NC <- sapply(words_NC, function(x) gsub("유전자", "DNA", x))
words_NC <- sapply(words_NC, function(x) gsub("휴대전화", "휴대폰", x))
words_NC <- sapply(words_NC, function(x) gsub("정보통신기술", "ICT", x))
words_NC <- sapply(words_NC, function(x) gsub("DRONE", "드론", x))
words_NC <- sapply(words_NC, function(x) gsub("롱텀에볼루션", "LTE", x))
words_NC <- sapply(words_NC, function(x) gsub("엘티이", "LTE", x))
words_NC <- sapply(words_NC, function(x) gsub("4차산업혁명.", "4차산업혁명", x))
words_NC <- sapply(words_NC, function(x) gsub("알파고.", "알파고", x))
words_NC <- sapply(words_NC, function(x) gsub("발사가", "발사", x))
words_NC <- sapply(words_NC, function(x) gsub("MP3플레이어", "MP3", x))
words_NC <- sapply(words_NC, function(x) gsub("지상파DMB", "DMB", x))
words_NC <- sapply(words_NC, function(x) gsub("전자신문인터넷", "전자신문", x))
words_NC <- sapply(words_NC, function(x) gsub("사물인터넷", "IOT", x))
words_NC <- sapply(words_NC, function(x) gsub("가상현실", "VR", x))
words_NC <- sapply(words_NC, function(x) gsub("증강현실", "AR", x))
words_NC <- sapply(words_NC, function(x) gsub("유기발광다이오드", "OLED", x))
words_NC <- sapply(words_NC, function(x) gsub("AI", "인공지능", x))


#------------------------------------------------------------------
#                 불용어 리스트에 있는 단어 제거
#------------------------------------------------------------------
# 불용어 리스트 불러오기
remove_list <- read.table("science_IT_data/remove_list.txt", header=T)
remove_list <- unlist(remove_list)
remove_list <- as.character(remove_list)


# 불용어 삭제
remove_list <- sort(remove_list, decreasing=T)
r <- length(remove_list)

for(i in 1:r){
  word <- remove_list[i]
  
  words_NC <- sapply(words_NC, function(x) gsub(word,"", x))
  words_NC <- sapply(words_NC, 
                     function(x) Filter(function(y) {nchar(y) >= 1}, x))
  
  cat(i,".",word,"remove.\n")
}



#------------------------------------------------------------------
#                        데이터 저장
#------------------------------------------------------------------
Q4_words_NC <- words_NC
save(Q4_words_NC, file="science_IT_data/2017/2017_4Q_words_NC.RData")



#------------------------------------------------------------------
#                임시저장한 데이터 불러오기
#------------------------------------------------------------------
load("science_IT_data/2017/2017_4Q_words_NC.RData")
words_NC <- Q4_words_NC



rm(Q1_words)
rm(Q1_words_NC)
rm(list=ls())
