class Vertex:
    def __init__(self, name):
        self.name = name


class Node(Vertex):
    def __init__(self, R=None, Psum=0, Msum=0, level=0, name=""):
        super().__init__(name)
        self.R = R if R is not None else []
        self.Psum = Psum
        self.Msum = Msum
        self.level = level


class Edge:
    def __init__(self, v1, v2, weight):
        self.v1 = v1
        self.v2 = v2
        self.weight = weight


# Other parts of your code remain unchanged.


def tps_bb(G):
    startNode = Node(R=[list(V)[0]], Psum=0, Msum=0, level=0, name=list(V)[0].name)
    startNode.Msum = sum(E[minEdge(i, V - {i})] for i in V)  # Updated Msum calculation
    Min = float('inf')
    S = {startNode}  # Changed from S = set() to ensure startNode is added to S
    R = []  # Initialize R to ensure it's defined

    while S:
        min_node = min(S, key=lambda node: node.Msum)
        S.remove(min_node)
        cNode = min_node
        if cNode.Msum >= Min:
            break
        level = cNode.level + 1
        for u in V - set(cNode.R[0:cNode.level]):
            uNode = Node(
                level=level,
                R=cNode.R + [u],
                name=u.name,
            )
            uNode.Psum = cNode.Psum + E.get((uNode.R[cNode.level], u), float('inf'))  # Updated to handle missing edges
            uNode.Msum = uNode.Psum + E.get(minEdge(u, V - set(uNode.R[0:level])), float('inf'))  # Updated to handle missing edges
            for w in V - set(uNode.R[0:uNode.level]):
                uNode.Msum += E.get(minEdge(w, V - set(uNode.R[0:uNode.level])), float('inf'))  # Updated to handle missing edges
            if uNode.Msum < Min:
                if uNode.level == len(V) - 2:
                    Min = uNode.Msum
                    R = uNode.R
                else:
                    S.add(uNode)
    return R, Min

# takes in a vertex and a set of vertices ad returns an edge with the minimum weight
def minEdge(i, V):
    min_weight = float('inf')
    edge = None
    for v in V:
        if v != i and E.get((i, v), float('inf')) < min_weight:  # check v != i to prevent self-loop, and use E.get() to handle missing keys
            min_weight = E[(i, v)]
            edge = (i, v)
    return edge



# Rest of your code remains unchanged.
# Create instances of the Vertex class
seoul = Vertex("seoul")
tokyo = Vertex("tokyo")
shanghai = Vertex("shanghai")
taipei = Vertex("taipei")
hongkong = Vertex("hongkong")

V = {seoul, tokyo, shanghai, taipei, hongkong} # set of vertices, {a, b, c, d, e, ...}
E = {
    (seoul, tokyo): 1151,
    (seoul, shanghai): 1214,
    (seoul, taipei): 2103,
    (seoul, hongkong): 2145,
    (tokyo, seoul): 1151,
    (tokyo, shanghai): 1745,
    (tokyo, taipei): 2248,
    (tokyo, hongkong): 2965,
    (shanghai, seoul): 1214,
    (shanghai, tokyo): 1745,
    (shanghai, taipei): 655,
    (shanghai, hongkong): 1437,
    (taipei, seoul): 2103,
    (taipei, tokyo): 2248,
    (taipei, shanghai): 655,
    (taipei, hongkong): 805,
    (hongkong, seoul): 2145,
    (hongkong, tokyo): 2965,
    (hongkong, shanghai): 1437,
    (hongkong, taipei): 805
} # {tuples(u, v): weight}
G = (V, E)

S = set() # set of nodes

path, totalDistance = tps_bb(G)
for city in path:
    print(city.name)

print (totalDistance)
