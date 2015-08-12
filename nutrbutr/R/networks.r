# Network Creation 
# Simple Example 

# First we need a function to column label entries of a dataframe

df = data.frame(year1 = c(1,2,3,1,1,1), year2 = c(1,1,1,2,2,2), year3 = c(1,1,1,1,1,1))
df2 = create_column_unique_entries(df)
row_transitions(df2)

create_column_unique_entries <- function(df, seperator = "_"){
  df2 <- df 
  for (i in 1:dim(df)[2]){
    df2[,i] = paste(df[,i], names(df)[i], sep=seperator) 
  }
  return(df2)
}

row_transitions <- function(df){
  df2 = data.frame(Var1 = c(), Var2= c(), Freq = c())
  n = dim(df)[2]-1 # How Many Columns to Scan
  for (i in 1:n){
    t = as.data.frame(table(df[,i], df[, i+1]))
    df2 = rbind(df2,t)
  }
  df2
}

break_out_value_and_year <- function(df, sep = "."){
  l <- strsplit(as.character(n$Var1), ".", fixed = TRUE)
  df$value <- as.factor(sapply(l, function(x) x[1]))
  df$year <- as.factor(sapply(l, function(x) x[2]))
  df
}





# CREATE TEST: First we need a function to column label entries of a dataframe
# df = data.frame(year1 = c(1,2,3,1,1,1), year2 = c(1,1,1,2,2,2), year3 = c(1,1,1,1,1,1))
# df2 = create_column_unique_entries(df)
# row_transitions(df2)

nutr <- readRDS("/Users/koshlan/Dropbox/KernCounty/nutrbutr_example_polygons.rds")
n = row_transitions(create_column_unique_entries(nutr@data[,c(22:28)], sep = ".")) # 
n = break_out_value_and_year(n)
n75 = head(n[n$value == 75,]) 
head(dplyr::arrange(n, desc(Freq)))






