##########################################################################################
#                                  Loading Texts                                         #
##########################################################################################      
#
#     Start by saving your text files in a folder titled:    "texts"
#     This will be the "corpus" (body) of texts you are mining.   
#  
#     Next, choose the type of computer you have...

system("defaults write org.R-project.R force.LANG es_US.UTF-8")
Sys.setenv(LANG="es")


######
# **On a Mac**, save the folder to your *desktop* and use the following code chunk:
######
cname <- file.path("~", "Desktop", "texts")   
cname   
dir(cname)   # Use this to check to see that your texts have loaded.   



######    
# *On a PC*, save the folder to your *C: drive* and use the following code chunk:  
######
cname <- file.path("D:/dev/curso-analisis-datos/tour-a/atractivo-turistico/data-scraping-to-tripadvisor/datasets")   
cname   
dir(cname)  




## Loading required package: NLP
library(NLP)
library(tm)

docs <- VCorpus(DirSource(cname))   
summary(docs)   

inspect(docs[1])
writeLines(as.character(docs[1]))

# Remover caracteres especiales
for (j in seq(docs)) {
  docs[[j]] <- gsub("/", " ", docs[[j]])
  docs[[j]] <- gsub("@", " ", docs[[j]])
  docs[[j]] <- gsub("\\|", " ", docs[[j]])
  docs[[j]] <- gsub("\\n", " ", docs[[j]])
  docs[[j]] <- gsub("\u2028", " ", docs[[j]])  # This is an ascii character that did not translate, so it had to be removed.
}

# Pre proceso del texto
docs <- tm_map(docs,removePunctuation)  
docs <- tm_map(docs, removeNumbers)   
docs <- tm_map(docs, tolower)   
docs <- tm_map(docs, removeWords, stopwords("spanish"))   
docs <- tm_map(docs, stemDocument, language = "spanish") 
#docs <- tm_map(docs, removeWords, c("syllogism", "tautology"))   
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument)
# *This is the end of the preprocessing stage.*   



### Stage the Data      
dtm <- DocumentTermMatrix(docs)   
tdm <- TermDocumentMatrix(docs)   

### Explore your data      
freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq)  
ord

m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="D:/dev/curso-analisis-datos/tour-a/atractivo-turistico/data-scraping-to-tripadvisor/DocumentTermMatrix.csv")   

### FOCUS - on just the interesting stuff...   
#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
### Word Frequency   
head(table(freq), 20)   
# The above output is two rows of numbers. The top number is the frequency with which 
# words appear and the bottom number reflects how many words appear that frequently. 
#
tail(table(freq), 20)   
# Considering only the 20 greatest frequencies
#
# **View a table of the terms after removing sparse terms, as above.
freq <- colSums(as.matrix(dtms))   
freq   
# The above matrix was created using a data transformation we made earlier. 
# **An alternate view of term frequency:**   
# This will identify all terms that appear frequently (in this case, 50 or more times).   
findFreqTerms(dtm, lowfreq=50)   # Change "50" to whatever is most appropriate for your data.
#
#
#   

### Plot Word Frequencies
# **Plot words that appear at least 50 times.**   
library(ggplot2)   
wf <- data.frame(word=names(freq), freq=freq)   
p <- ggplot(subset(wf, freq>50), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p   

#  
## Relationships Between Terms
### Term Correlations
# See the description above for more guidance with correlations.
# If words always appear together, then correlation=1.0.    
findAssocs(dtm, c("country" , "american"), corlimit=0.85) # specifying a correlation limit of 0.85
findAssocs(dtms, "think", corlimit=0.70) # specifying a correlation limit of 0.95   
# 
# Change "country" & "american", or "think" to terms that actually appear in your texts.
# Also adjust the `corlimit= ` to any value you feel is necessary.
#
# 
### Word Clouds!   
# First load the package that makes word clouds in R.    
library(wordcloud)   
dtms <- removeSparseTerms(dtm, 0.15) # Prepare the data (max 15% empty space)   
freq <- colSums(as.matrix(dtm)) # Find word frequencies   
dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2)    



### Clustering by Term Similarity

### Hierarchal Clustering   
dtms <- removeSparseTerms(dtm, 0.15) # This makes a matrix that is only 15% empty space.
library(cluster)   
d <- dist(t(dtms), method="euclidian")   # First calculate distance between words
fit <- hclust(d=d, method="complete")    # Also try: method="ward.D"   
plot.new()
plot(fit, hang=-1)
groups <- cutree(fit, k=6)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=6, border="red") # draw dendogram with red borders around the 5 clusters   

### K-means clustering   
library(fpc)   
library(cluster)  
dtms <- removeSparseTerms(dtm, 0.15) # Prepare the data (max 15% empty space)   
d <- dist(t(dtms), method="euclidian")   
kfit <- kmeans(d, 2)   
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)  
