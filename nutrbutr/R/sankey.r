# SanKey

require(igraph)
require(rCharts)
g <- graph.tree(30, children = 4)

E(g)$weight = 1
edgelist <-get.data.frame(g)
edgelist
colnames(edgelist) <- c("source","target","value")
edgelist$source <- as.character(edgelist$source)
edgelist$target <- as.character(edgelist$target)


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


g2 <- graph.tree(40, children=4)

#to construct a sankey the weight of each vertex should be the sum
#of its outgoing edges
#I believe the first step in creating a network that satisfies this condition
#is define a vertex weight for all vertexes with out degree = 0
#but first let's define 0 for all
V(g2)$weight = 0
V(g2)$weight
#now for all vertexes with out degree = 0
V(g2)[degree(g2,mode="out")==0]$weight <- runif(n=length(V(g2)[degree(g2,mode="out")==0]),min=0,max=100)
#the lowest level of the heirarchy is defined with a random weight
#with the lowest level defined we should now be able to sum the vertex weights
#to define the edge weight
#E(g2)$weight = 0.1 #define all weights small to visually see as we build sankey
E(g2)[to(V(g2)$weight>0)]$weight <- V(g2)[V(g2)$weight>0]$weight
#and to find the neighbors to the 0 out degree vertex
#we could do V(g2)[nei(degree(g2,mode="out")==0)]
#we have everything we need to build the rest by summing
#these edge weights if there are edges still undefined
#so set up a loop to run until all edges have a defined weight
while(max(is.na(E(g2)$weight))) {
  #get.data.frame gives us from, to, and weight
  #we will get this to make an easier reference later
  df <- get.data.frame(g2)
  #now go through each edge and find the sum of all its subedges
  #we need to check to make sure out degree of its "to" vertex is not 0
  #or we will get 0 since there are no edges for vertex with out degree 0
  for (i in 1:nrow(df)) {
    x = df[i,]
    #sum only those with out degree > 0 or sum will be 0
    if(max(df$from==x$to)) {
      E(g2)[from(x$from) & to(x$to)]$weight = sum(E(g2)[from(x$to)]$weight)
    }
  }
}
edgelistWeight <- get.data.frame(g2)
colnames(edgelistWeight) <- c("source","target","value")
edgelistWeight$source <- as.character(edgelistWeight$source)
edgelistWeight$target <- as.character(edgelistWeight$target)
sankeyPlot2 <- rCharts$new()
sankeyPlot2$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey')
sankeyPlot2$setTemplate(
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

sankeyPlot2$set(
  data = edgelistWeight,
  nodeWidth = 15,
  nodePadding = 10,
  layout = 32,
  width = 960,
  height = 500
)
sankeyPlot2


simple <- read.table("/Users/koshlan/Desktop/nutrbutr/nutrbutr/data/simple.txt", header=T)
g<-graph.data.frame(simple, directed=T)
plot(g)
E(simple.network)$weight <- simple$value






edgelist <-get.data.frame(g)
edgelist
colnames(edgelist) <- c("source","target","value")
edgelist <- edgelist[,1:3]
edgelist
edgelist$source <- as.character(edgelist$source)
edgelist$target <- as.character(edgelist$target)


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