---
layout: projects 
title: Idea&#58 Historical Election Data 
mathjax: true
---

National Election Results for historical elections can be found [here](https://history.house.gov/Institution/Election-Statistics/Election-Statistics/). The information contained in these PDFs are the certified election results for federal elections going all the way back to 1920. This is all pretty well known and looking up a single result is pretty easy. The data itself is not, however, digitized (I got this idea reading the tweet below). 

<div style="text-align: center"><img src="/images/OpenElections.png" width="500" /></div>

An interesting project would be to digitize the results and put them in a data repository. The data itself is small enough that you could conceivably put your code and the resulting data into github. To give you a sense of what these pages look like, the following is a sample:


<div style="text-align: center"><img src="/images/OpenElections2.png" width="500" /></div>

As you can see the data is pretty straight forward -- it is a set of tables with election results put in a pretty standard format. It wouldn't surprise me if you could combine an off the shelf deep learning based tabular OCR system with a ton of annoying glue code to generate this data. Importantly, there are a _lot_ of ways that you could error check the OCR process since much of the data also contains summary statistics. 
