import numpy as np
import matplotlib.pyplot as plt


def plotfile(file1, file2, xname, yname):
    with open(file1, 'r') as file:
        dataold = file.read()

    with open(file2, 'r') as file:
        datanew = file.read()

    x_old = list(map(str, dataold.split('\n')))
    x_new = list(map(str, datanew.split('\n')))

    x_old.pop()
    x_new.pop()

    y_old = []
    num = 0
    for i in x_old:
        y_old.append(np.array(list(map(float, x_old[num].split()))))
        num += 1

    y_old = np.array(y_old)

    y_new = []
    num = 0
    for i in x_new:
        y_new.append(np.array(list(map(int, x_new[num].split()))))
        num += 1

    y_new = np.array(y_new)

    fig = plt.figure()
    ax = plt.axes()

    x = np.linspace(0, 10, 1000)

    plt.plot(y_old[:, 0], y_old[:, 1], label="old_leach")
    plt.plot(y_new[:, 0], y_new[:, 1], label="new_leach")
    plt.xlabel(xname)
    plt.ylabel(yname)
    plt.legend()
