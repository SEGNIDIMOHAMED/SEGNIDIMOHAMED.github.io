---
layout: page
title: About
permalink: /about/
---

{%- capture intro -%}{% include_relative intro.md %}{%- endcapture -%}
<div>{{ intro | markdownify }}</div>
