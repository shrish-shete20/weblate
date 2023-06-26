---
title: "Themed dashboard"
output: 
  flexdashboard::flex_dashboard:
    theme:
      version: 4
      bootswatch: minty
      heading_font:
        google: Sen
      base_font: 
        google: Prompt
    orientation: rows
    vertical_layout: scroll
    source_code: embed
    navbar:
      - { title: "Github", href: "https://github.com/shrish-shete20/weblate", align: right, icon: fa-github}
    css: ["fragments/custom.css"]
---




Sidebar {.sidebar data-width=200}
=====================================
<div class="knitr-options" data-fig-width="576" data-fig-height="460"></div>

```{=html}
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
     <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
             
</head>

<body>
    <div class="navlink-column">
        <a class="navlink" href="#Leaderboard" aria-expanded="false">  <span class="material-symbols-outlined">leaderboard</span> Leaderboard</a>
        <a class="navlink" href="#world-map" aria-expanded="false"><i class="fa fa-globe"></i> World Map</a>
        <a class="navlink" href="#Languages" aria-expanded="false"><i class="fa fa-language"></i> Languages</a>
        <a class="navlink" href="#Packages" aria-expanded="false"><i class="fa fa-info"></i> Packages</a>
        <a class="navlink" href="#Translations" aria-expanded="false"><i class="fa fa-line-chart"></i> Translations</a>
        <a class="navlink" href="#Information" aria-expanded="false"><i class="fa fa-info"></i> Information</a>
    </div>
</body>

</html>
```


