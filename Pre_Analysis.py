import csv
import sys
#Short script to obtain the length of each game played in a given csv file.

if len(sys.argv)==1:
    file=open("Shut_the_Box.csv","rb")
else:
    file=open(sys.argv[1],"rb")

data=csv.reader(file)
data=[row for row in data]
file.close()

new_data=[data[0]]
for e in data[1:]:
    row=[]
    for a in e:
        a=eval(a)
        if type(a) is int:
            row.append(a)
        else:
            row.append(len(a))
    new_data.append(row)


file=open("Data_for_Analysis.csv","wb")
output=csv.writer(file)

for row in new_data:
    output.writerow(row)

file.close()
