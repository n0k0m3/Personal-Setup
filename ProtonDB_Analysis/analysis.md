---
layout: default
title: ProtonDB Analysis
parent: Data Analysis
grand_parent: Projects
nav_order: 1
---
## Analysis of ProtonDB Linux Distribution


### Data Preprocessing


[Notebook link](https://github.com/n0k0m3/Personal-Setup/blob/main/ProtonDB_Analysis/analysis.ipynb){: .btn }


### Cumulative Results


**Note:** On Dec 2nd 2019, ProtonDB contribute workflow changed to a questionnaire, subsequently changed the data structures. All data prior to this date are for reference only and should NOT be inferred.


#### Raw user counts per distro



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_6.html"
    frameborder="0"
    allowfullscreen
></iframe>



#### Normalized distro market share on ProtonDB



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_7.html"
    frameborder="0"
    allowfullscreen
></iframe>



#### Normalized distro market share on ProtonDB (Merged distro base)



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_9.html"
    frameborder="0"
    allowfullscreen
></iframe>



Arch Linux and Arch-based distro is on the rise, while Debian-based (Ubuntu) distros are on the decline.


### Steam Deck/SteamOS effect on ProtonDB market share analysis

Is there a shift due to Steam Deck and SteamOS? We'll filter from Jan 1st 2022 till now to see if there is a shift in the market share.



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_10.html"
    frameborder="0"
    allowfullscreen
></iframe>



Let's group the distro by their bases.



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_11.html"
    frameborder="0"
    allowfullscreen
></iframe>



As we can see, the market share graph doesn't show that there's any effect of Steam Deck release on ProtonDB user base. Let's check monthly increased user counts to see if there's any change.


#### Monthly delta of user counts



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_13.html"
    frameborder="0"
    allowfullscreen
></iframe>



Let's zoom in after Dec 2nd 2019 (when the questionnaire was released)



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_14.html"
    frameborder="0"
    allowfullscreen
></iframe>



Debian and Fedora experienced a spike in new user count. More analysis on the market is needed.



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_16.html"
    frameborder="0"
    allowfullscreen
></iframe>



Debian-based new installation is on a constant decline, while arch and "other" distros are on a rise. As the market share of "other" distros is not as significant as Debian or Arch derivatives, we won't go deeper into this category.



<iframe
    scrolling="no"
    width="620px"
    height="420"
    src="iframe_figures/figure_17.html"
    frameborder="0"
    allowfullscreen
></iframe>



New install of both Arch and Debian-based distros is on plateau. So for now, the release of Steam Deck is not that big of a disruption. Interestingly, by the end of March there is a spike in installation of Fedora due to a beta release of Fedora 36.

