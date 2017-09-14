import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def plotAll():
	with open("test.dat") as fp:
		lines = fp.readlines()
	pg1 = [float(s) for s in lines[0][1:-2].split(',')]
	pg2 = [float(s) for s in lines[1][1:-2].split(',')]
	couch = [float(s) for s in lines[2][1:-2].split(',')]
	mongo = [float(s) for s in lines[3][1:-2].split(',')]

	for i in range(8):
		a =[pg1[i],pg2[i],couch[i],mongo[i]]
		if i>0 and i<7:
			b=[int(y*1000) for y in a]
			a=b
		N = 4
		ind = np.arange(N)  # the x locations for the groups
		width =1/1.5      # the width of the bars
		s = pd.Series(
		a,
		index = ["PostgreSQL\n JSONB", "PostgreSQL\n JSON", "Couchbase", "MongoDB"]
		)
	

		my_colors = 'rgbkymc'  #red, green, blue, black, etc.

		ax=s.plot(kind='bar',color=my_colors,rot=0, alpha = 0.9)
		ax.set_ylabel("Time[s]")
		if i>0 and i<7:
			ax.set_ylabel("Time[ms]")
		if i==7:
			ax.set_ylabel("Size[MB]")
		fig=ax.get_figure()
		fig.savefig('fig'+str(i)+'.png')
		fig.clf()

def plotIndex():
	with open("test2.dat") as fp:
		lines = fp.readlines()
	t = [float(s) for s in lines[0][1:-2].split(',')]
	N = 2
	ind = np.arange(N)  # the x locations for the groups
	width =1/1.5      # the width of the bars
	s = pd.Series(
	t,
	index = ["Bez indeksu", "Z indeksem"]
	)
	

	my_colors = 'rgbkymc'  #red, green, blue, black, etc.

	ax=s.plot(kind='bar',color=my_colors,rot=0, alpha = 0.9)
	ax.set_ylabel("Time[s]")

	ax.set_ylabel("Time[ms]")
	
			
	fig=ax.get_figure()
	fig.savefig('figindex.png')
	fig.clf()
	

