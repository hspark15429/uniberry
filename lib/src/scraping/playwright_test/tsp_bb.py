class Vertex:
    def __init__(self, name):
        self.name = name

class Node(Vertex):
    def __init__(self, R=[], Psum=0, Msum=0, level=0, name=""):
        super().__init__(name)
        self.R = R
        self.Psum = Psum
        self.Msum = Msum
        self.level = level

class Edge:
    def __init__(self, v1, v2, weight):
        self.v1 = v1
        self.v2 = v2
        self.weight = weight



# Create instances of the Vertex class
seoul = Vertex("seoul")
tokyo = Vertex("tokyo")
shanghai = Vertex("shanghai")
taipei = Vertex("taipei")
hongkong = Vertex("hongkong")

V = {seoul, tokyo, shanghai, taipei, hongkong} # set of vertices, {a, b, c, d, e, ...}
E = {
    (seoul, tokyo): 3,
    (seoul, shanghai): 1,
    (seoul, taipei): 3,
    (seoul, hongkong): 6,
    (tokyo, seoul): 3,
    (tokyo, shanghai): 3,
    (tokyo, taipei): 3,
    (tokyo, hongkong): 5,
    (shanghai, seoul): 1,
    (shanghai, tokyo): 3,
    (shanghai, taipei): 2,
    (shanghai, hongkong): 7,
    (taipei, seoul): 3,
    (taipei, tokyo): 3,
    (taipei, shanghai): 2,
    (taipei, hongkong): 5,
    (hongkong, seoul): 6,
    (hongkong, tokyo): 5,
    (hongkong, shanghai): 7,
    (hongkong, taipei): 5
} # {tuples(u, v): weight}
G = (V, E)

S = set() # set of nodes

def tps_bb(G):
    startNode = Node(R=[list(V)[0]], Psum=0, Msum=0, level=0, name=list(V)[0].name)
    for i in V:
        startNode.Msum += E[minEdge(i, V - {i})]
    Min = float('inf')
    S.add(startNode)
    while S:
        print(len(S)) 
        min_node = min(S, key=lambda node: node.Msum)
        S.remove(min_node)
        cNode = min_node
        if cNode.Msum >= Min: break
        level = cNode.level + 1
        for u in V - set(cNode.R[0:cNode.level+1]):
            uNode = Node(
                level=level,
                R=cNode.R + [u],
                name=u.name,
                )
            uNode.Psum = cNode.Psum + E[uNode.R[cNode.level], u]
            uNode.Msum = uNode.Psum + E[minEdge(u, V - set(uNode.R[0:level+1]))]
            for w in (V - set(uNode.R[0:uNode.level+1])):
                uNode.Msum += E[minEdge(w, (V - set(uNode.R[1:uNode.level+1])-{w}))]
            if uNode.Msum<Min:
                if uNode.level == len(V)-2:
                    Min = uNode.Msum
                    R = uNode.R
                else:
                    S.add(uNode)
    return R, Min


# takes in a vertex and a set of vertices ad returns an edge with the minimum weight
def minEdge(i, V):
    min = float('inf')
    edge = None
    for v in V:
        if E[(i, v)] < min:
            min = E[(i, v)]
            edge = (i, v)
        # print(i.name, "to", v.name, "is", E[(i, v)], "km")
    return edge

path, distance = tps_bb(G)
print(list(map(lambda x: x.name, path)))
print(distance)