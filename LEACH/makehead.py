import numpy as np
from sklearn.cluster import KMeans


with open('dataset.txt', 'r') as file:
    data = file.read()

x = list(map(str, data.split('\n')))
x.pop()

y = []
num = 0
for i in x:
    y.append(np.array(list(map(float, x[num].split()))))
    num += 1

y = np.array(y)
X_inputs = y[:, 1:3]
y_weights = y[:, 3]
# print(X_inputs, y_weights)

num_clust = len(x)//10

kmw = KMeans(
    n_clusters=num_clust, init='random',
    n_init=10, max_iter=300,
    tol=1e-04, random_state=0
)
y_kmw = kmw.fit_predict(X_inputs, y_weights)


with open('cluster_assigned.txt', 'w') as f:
    for i in range(len(y_kmw)):
        f.write("%d %d\n" % (y[i, 0], y_kmw[i]))

maxen = []
for i in range(num_clust):
    maxen.append([0.0, 0.0])

for i in range(len(x)):
    kaunsa_cluster = y_kmw[i]
    energy = y[i, 3]
    # print(kaunsa_cluster, energy, maxen[kaunsa_cluster][1], y[i, 0])
    if energy > maxen[kaunsa_cluster][1]:
        maxen[kaunsa_cluster] = [y[i, 0], energy]

with open('cluster_heads.txt', 'w') as f:
    for i in range(num_clust):
        f.write("%d\n" % maxen[i][0])
