---
layout: projects 
title: Election Prediction (2018-2020)
mathjax: true
---

Working closely with ABC News, built an election prediction platform which ingested night-of election results in real-time and then estimated the likelihood of each party winning.  A nice write-up can be found [here](https://www.usfca.edu/news/dons-data-abc). The project itself was an incredible success with **_zero_** downtime on any of the nights in question.


This platform did _not_ use polling information, instead estimating win probabilities by comparing precinct level results as they came in against those same precincts in previous elections.

The platform was built by a team of Masters students and USF Professors. On election night the platform went live. In order to keep the platform as easy to develop on as possible we settled on the following technologies:

* Python (which is what the Master Students are taught in)
* [Flask](https://flask.palletsprojects.com/en/2.0.x/)
* AWS (EC2 for compute/S3 for storage)
* Docker

On the night of the election (and primaries) a team in SF oversaw the system while another team (in NYC) used the system in order to provide live analysis and updates for ABC news.



[![USF Link](/images/dons_data.png)](https://www.usfca.edu/news/dons-data-abc)


