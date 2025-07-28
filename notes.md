---
layout: default
---

{% assign sorted = site.notes | reverse %}
{% for item in sorted %}
  <p><a href="{{ item.url }}">{{ item.title }}: {{ item.date | date: "%Y %B" }} </a></p>
{% endfor %}
