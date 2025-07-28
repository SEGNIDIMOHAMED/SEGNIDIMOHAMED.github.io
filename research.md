---
layout: default
---

In this section you can information about the papers I've published, their abstracts and links. 

{% assign sorted = site.research | reverse %}
{% for item in sorted %}
  <p><h4><a href="{{ item.url }}">{{ item.title }} ({{ item.year}})</a></h4></p>
{% endfor %}


