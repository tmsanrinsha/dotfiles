library(DiagrammeR)
library(data.table)
library(magrittr)

dt <- fread('2015-11-14-144111.tsv')

nodes_df <- create_nodes(nodes = c(dt$V1,dt$V4),
                         label = FALSE)

# nodes_df <- create_nodes(nodes = c(dt$V1,dt$V4),
#                          label = FALSE)

# The edge data frame must have columns named 'from' and 'to'
# The color attribute is determined with an 'ifelse' statement, where
# column 8 is the minutes early (negative values) or minutes late (positive values)
# for the flight arrival
# edges_df <- create_edges(from = nycflights13_day[,12],
#                          to = nycflights13_day[,13],
#                          color = ifelse(nycflights13_day[,8] < 0,
#                                     "green", "red"))

# for (i in seq(along=dt$V1)) {
#     print(dt$V1[i])
#     edges_df <- create_edges(from = dt$V4[i],
#                              to = dt$V1[i])
# }
#     edges_df2 <- create_edges(from = dt$V4[1],
#                               to = dt$V1[1])

edges_df <- create_edges(from = dt$V4,
                         to = dt$V1,
                         penwidth = log(dt$V3))

# Set the graph diagram's default attributes for...

# ...nodes
# node_attrs <- c("style = filled", "fillcolor = lightblue",
#                 "color = gray", "shape = circle", "fontname = Helvetica",
#                 "width = 1")

# ...edges
# edge_attrs <- c("arrowhead = dot")

# ...and the graph itself
# graph_attrs <- c("layout = circo",
#                  "overlap = false",
#                  "fixedsize = true",
#                  "ranksep = 3",
#                  "outputorder = edgesfirst")

create_graph(nodes_df = nodes_df,
             edges_df = edges_df,
             directed = TRUE) %>%
    render_graph(width = 1600, height = 1200)
             # graph_attrs = graph_attrs,
             # node_attrs = node_attrs,
             # edge_attrs = edge_attrs,

# Generate the graph diagram in the RStudio Viewer.
# create_graph(nodes_df = nodes_df, edges_df = edges_df,
#                graph_attrs = graph_attrs, node_attrs = node_attrs,
#                edge_attrs = edge_attrs, directed = TRUE) %>%
  # render_graph(width = 1200, height = 800)

# graph <- create_graph(nodes_df = nodes_df,
#                     edges_df = edges_df2)
# render_graph(graph)
