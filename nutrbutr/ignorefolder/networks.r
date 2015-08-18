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
  l <- strsplit(as.character(n$Var2), ".", fixed = TRUE)
  df$value2 <- as.factor(sapply(l, function(x) x[1]))
  df$year2 <- as.factor(sapply(l, function(x) x[2]))
  df
}

# CREATE TEST: First we need a function to column label entries of a dataframe
# df = data.frame(year1 = c(1,2,3,1,1,1), year2 = c(1,1,1,2,2,2), year3 = c(1,1,1,1,1,1))
# df2 = create_column_unique_entries(df)
# row_transitions(df2)

nutr <- readRDS("/Users/koshlan/Dropbox/KernCounty/nutrbutr_example_polygons.rds")
n = row_transitions(create_column_unique_entries(nutr@data[,c(28:22)], sep = ".")) # 
head(n)
n = break_out_value_and_year(n)
head(n)

crops <- c(24,36,61,69,75,204,176)
n75 = n[n$value %in% crops & n$value2 %in%crops,]
n75 = n75[n75$Freq > 0 ,]
head(n75)
dim(n75)
n75a <- dplyr::arrange(n75, desc(Freq))
n75a
g<-graph.data.frame(n75a, directed=T)
plot(g)
E(g)$weight <- n75a$Freq
E(g)$weight

edgelist <-get.data.frame(g)
edgelist

edgelist <- edgelist[,1:3]
head(edgelist)
colnames(edgelist) <- c("source","target","value")
edgelist$source <- as.character(edgelist$source)
edgelist$target <- as.character(edgelist$target)
head(edgelist)
sankeyPlot <- rCharts$new()
sankeyPlot$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey')
sankeyPlot$setTemplate(
  afterScript = "
  <script>
  // to be specific in case you have more than one chart
  d3.selectAll('#{{ chartId }} svg path.link')
  .style('stroke', function(d){
  //here we will use the source color
  //if you want target then sub target for source
  //or if you want something other than gray
  //supply a constant
  //or use a categorical scale or gradient
  return d.source.color;
  })
  //note no changes were made to opacity
  //to do uncomment below but will affect mouseover
  //so will need to define mouseover and mouseout
  //happy to show how to do this also
  // .style('stroke-opacity', .7) 
  </script>
  ")

sankeyPlot$set(
  data = edgelist,
  nodeWidth = 15,
  nodePadding = 10,
  layout = 32,
  width = 960,
  height = 500
)
sankeyPlot








