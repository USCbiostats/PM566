
# Course Material for PM566

The PM566 course website is
[here](https://elastic-khorana-70231e.netlify.app/). We will be using
this website to share all course material including lecture slides,
labs, and assignments.

Our class meets at 1pm every Wednesday. Zoom links for each lecture
session are available in the course Blackboard.

# Latest week’s cross reference

This is an example of web scrapping. We built this program to extract
the cross-reference links from a given GitHub issue, including details
such as timestamp, the user, and the commit message.

You can download the program [here](lost_cross_ref.R)

``` r
library(data.table)
library(stringr)
```

``` r
# Web-scraping program
source("list_cross_ref.R", echo=FALSE)

# Getting the cross reference for a given issue
ans <- list_cross_ref(issue = 25)
```

    ## Warning in if (xml_length(items) == 0) stop("No cross-reference to be
    ## analized."): the condition has length > 1 and only the first element will be
    ## used

``` r
# Preparing to print using a nice format
ans[, user := sprintf("[%s](https://github.com/%s)", user, user)]
ans[, repo_owner := str_extract(link, "(?<=github[.]com/)[^/]+")]
ans[, repo_owner := sprintf("[%s](https://github.com/%s)", repo_owner, repo_owner)]
ans[, link := sprintf("[link](%s)", link)]
setorder(ans, timestamp)

# A more concise message
ans[, message := sprintf("%s (%s to this %s)", title, link, type)]
ans[, c("title", "link", "type") := NULL] 
knitr::kable(ans)
```

| user                                              | timestamp           | repo\_owner                                       | message                                                                                                                                                                            |
| :------------------------------------------------ | :------------------ | :------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [HopeW233](https://github.com/HopeW233)           | 2020-09-23 21:33:23 | [HopeW233](https://github.com/HopeW233)           | Here is my HW2 \#25 ([link](https://github.com/HopeW233/Pm566HW/commit/aad73137dc25a272f6e96a6518f1d1fd4567da8d) to this homework)                                                 |
| [gvegayon](https://github.com/gvegayon)           | 2020-09-23 21:34:51 | [RuowenWang123](https://github.com/RuowenWang123) | Finish HW 2 <https://github.com/USCbiostats/PM566/issue/25> ([link](https://github.com/RuowenWang123/PM566-labs/commit/822e1bf4c5f9627c9ddd7757ec48e52cdcd0cd1e) to this homework) |
| [hankezhe](https://github.com/hankezhe)           | 2020-09-23 21:37:54 | [hankezhe](https://github.com/hankezhe)           | add HW2 \#25 ([link](https://github.com/hankezhe/PM566-LAB-ASSIGNMENT/commit/6a96e5e5ea4ccd6375af10e5958bdf5e41e551d5) to this homework)                                           |
| [stephtring](https://github.com/stephtring)       | 2020-09-23 21:42:21 | [stephtring](https://github.com/stephtring)       | HW2 “\#25” ([link](https://github.com/stephtring/HW2/commit/cd242ff9f8d2f3cb2c4cddee2d0e0f5c1b58175c) to this homework)                                                            |
| [hankezhe](https://github.com/hankezhe)           | 2020-09-23 22:40:39 | [hankezhe](https://github.com/hankezhe)           | add HW2 github doc \#25 ([link](https://github.com/hankezhe/PM566-LAB-ASSIGNMENT/commit/c9fec0ae71f9404169fbf180d8de37d63b1465dd) to this homework)                                |
| [HopeW233](https://github.com/HopeW233)           | 2020-09-23 22:47:58 | [HopeW233](https://github.com/HopeW233)           | finalizing HW2 \#25 ([link](https://github.com/HopeW233/Pm566HW/commit/641ff5eb6ade9ee6dc5d1cea38913e3eaa0db10b) to this homework)                                                 |
| [eshkim1021](https://github.com/eshkim1021)       | 2020-09-23 23:44:07 | [eshkim1021](https://github.com/eshkim1021)       | Finishing Lab 6 \#25 ([link](https://github.com/eshkim1021/PM-566-Lab-6/commit/f4db1c915997ecae4a07db3a14314045aaade5ac) to this lab)                                              |
| [jiaheche](https://github.com/jiaheche)           | 2020-09-23 23:48:14 | [jiaheche](https://github.com/jiaheche)           | Lab6 \#25 ([link](https://github.com/jiaheche/pm566-projects/commit/62a51a6d890fd9b9ff2e25138ddbd7ae81329005) to this lab)                                                         |
| [hankezhe](https://github.com/hankezhe)           | 2020-09-23 23:49:12 | [hankezhe](https://github.com/hankezhe)           | add Lab 06 github doc & rmd file \#25 ([link](https://github.com/hankezhe/PM566-LAB-ASSIGNMENT/commit/8e9d6e2fe5418c9c6eeaeade478d6a93f79fc2f1) to this lab)                       |
| [mbolshakova](https://github.com/mbolshakova)     | 2020-09-23 23:58:22 | [mbolshakova](https://github.com/mbolshakova)     | Adding Lab 6 “\#25” ([link](https://github.com/mbolshakova/PM566-labs/commit/d3b72ca8b74409c92404b6d384dc474c8f5cf75d) to this lab)                                                |
| [cbegay89](https://github.com/cbegay89)           | 2020-09-24 00:00:19 | [cbegay89](https://github.com/cbegay89)           | Lab 6 complete ([link](https://github.com/cbegay89/PM566-labs/commit/3a2cd1ceb1e8f426a6bff18420bdf9bdf4b2ed46) to this lab)                                                        |
| [slee2424](https://github.com/slee2424)           | 2020-09-24 00:00:54 | [slee2424](https://github.com/slee2424)           | Finalizing lab 6 \#25 ([link](https://github.com/slee2424/pm566_labs/commit/de8a3fdade7a9f2ee55620692ec1ccf400667b9a) to this lab)                                                 |
| [bcruiz](https://github.com/bcruiz)               | 2020-09-24 00:03:42 | [bcruiz](https://github.com/bcruiz)               | Assignment 2 USCbiostats/PM566\#25 ([link](https://github.com/bcruiz/Assignment2/commit/e2ad2f856271e3cb15d1269f8f025d42c2325a79) to this homework)                                |
| [MingzhiYe16](https://github.com/MingzhiYe16)     | 2020-09-24 00:14:07 | [MingzhiYe16](https://github.com/MingzhiYe16)     | \#25 ([link](https://github.com/MingzhiYe16/PM566lab6/commit/f0f3f55e33c085a71ce6985da0e650bfa3c177bb) to this NA)                                                                 |
| [MingzhiYe16](https://github.com/MingzhiYe16)     | 2020-09-24 00:15:46 | [MingzhiYe16](https://github.com/MingzhiYe16)     | This is the lab6 \#25 ([link](https://github.com/MingzhiYe16/PM566lab6/commit/aed814bfd63cb1d6c858fb9c16745c5121b6c538) to this lab)                                               |
| [MingzhiYe16](https://github.com/MingzhiYe16)     | 2020-09-24 00:16:24 | [MingzhiYe16](https://github.com/MingzhiYe16)     | This is the readme file \#25 ([link](https://github.com/MingzhiYe16/PM566lab6/commit/c0da2158b38111e89376abc69bcef58b70ed2eb2) to this NA)                                         |
| [bcruiz](https://github.com/bcruiz)               | 2020-09-24 00:38:36 | [bcruiz](https://github.com/bcruiz)               | Lab6 - USCbiostats/PM566\#25 ([link](https://github.com/bcruiz/PM566-Lab6/commit/897de8661a9cc2c8abf3df5ab243bb06780ae238) to this lab)                                            |
| [HopeW233](https://github.com/HopeW233)           | 2020-09-24 00:39:13 | [HopeW233](https://github.com/HopeW233)           | Finalizing HW2 ([link](https://github.com/HopeW233/Pm566HW/commit/d308cbacfc114966a4e978331b834f12f65e8450) to this homework)                                                      |
| [HopeW233](https://github.com/HopeW233)           | 2020-09-24 00:40:57 | [HopeW233](https://github.com/HopeW233)           | Finalizing Lab06 \#25 ([link](https://github.com/HopeW233/PM566-labs/commit/d8eb81e619b24b8c2d80085f2c63333a299b381a) to this lab)                                                 |
| [Shan-shan-666](https://github.com/Shan-shan-666) | 2020-09-24 00:46:00 | [Shan-shan-666](https://github.com/Shan-shan-666) | lab6\#25 ([link](https://github.com/Shan-shan-666/PM566/commit/385a9aa8027f451f86788f71643ef4ec9e589e12) to this lab)                                                              |
| [Luqing521](https://github.com/Luqing521)         | 2020-09-24 01:32:59 | [Luqing521](https://github.com/Luqing521)         | Finalizing lab06 \#25 ([link](https://github.com/Luqing521/PM566_Assignment/commit/11d10013a5fc33597bc17b117f4670974a6d1c06) to this lab)                                          |
| [shawnyeusc](https://github.com/shawnyeusc)       | 2020-09-24 01:43:20 | [shawnyeusc](https://github.com/shawnyeusc)       | lab06 \#25 ([link](https://github.com/shawnyeusc/PM566-labs/commit/54c296a5308b4c4c9a78aa586d002e0fd9864029) to this lab)                                                          |
| [Luqing521](https://github.com/Luqing521)         | 2020-09-24 02:09:02 | [Luqing521](https://github.com/Luqing521)         | HW\_02 \#25 ([link](https://github.com/Luqing521/PM566_Assignment/commit/f5a139b20e559c1957e542e1ac53000ac1328ae5) to this homework)                                               |
| [mbolshakova](https://github.com/mbolshakova)     | 2020-09-24 02:19:36 | [mbolshakova](https://github.com/mbolshakova)     | Homework 2 \#25 ([link](https://github.com/mbolshakova/PM566-Homework/commit/620cb52e89e358e7f2905fec9f0d0e291e8b4015) to this NA)                                                 |
| [yina-liu](https://github.com/yina-liu)           | 2020-09-24 02:23:03 | [yina-liu](https://github.com/yina-liu)           | Assignment done \#25 ([link](https://github.com/yina-liu/PM566-Assignments/commit/77ad92128dd8f9e1c2f69889092eeaccccb3a04a) to this homework)                                      |
| [mbolshakova](https://github.com/mbolshakova)     | 2020-09-24 02:24:23 | [mbolshakova](https://github.com/mbolshakova)     | \#25 ([link](https://github.com/mbolshakova/PM566-Homework/commit/9e38e9e056ec5c10cfe09ffed88a86be49273e5f) to this NA)                                                            |
| [yina-liu](https://github.com/yina-liu)           | 2020-09-24 02:46:50 | [yina-liu](https://github.com/yina-liu)           | Finalizing Lab06 \#25 ([link](https://github.com/yina-liu/PM566-Labs/commit/2a09762ba1e22cdd75661ce805371c21d1aab636) to this lab)                                                 |
| [stephtring](https://github.com/stephtring)       | 2020-09-24 03:22:21 | [stephtring](https://github.com/stephtring)       | Lab 6 “\#25” ([link](https://github.com/stephtring/PM566-labs/commit/ca76cb82dcc57fc7db5b61646cb840e6a9e0b994) to this lab)                                                        |
| [cbegay89](https://github.com/cbegay89)           | 2020-09-24 03:23:49 | [cbegay89](https://github.com/cbegay89)           | Assignment 2 ([link](https://github.com/cbegay89/PM566-labs/commit/b38042fd2a035bb46aaef3b9bf2d3ec35ce645a1) to this homework)                                                     |
| [jiaheche](https://github.com/jiaheche)           | 2020-09-24 04:28:10 | [jiaheche](https://github.com/jiaheche)           | Assignment2 \#25 ([link](https://github.com/jiaheche/pm566-projects/commit/264b85ae214f28f3d890595a56d205187dda5568) to this homework)                                             |
| [ameihao](https://github.com/ameihao)             | 2020-09-24 05:47:25 | [ameihao](https://github.com/ameihao)             | Finalizing HW2 \#25 ([link](https://github.com/ameihao/PM566-Homework/commit/e210bd12d7c5bb48884112b63735b9804ae67994) to this homework)                                           |
| [ameihao](https://github.com/ameihao)             | 2020-09-24 06:13:29 | [ameihao](https://github.com/ameihao)             | Finalizing Lab6 \#25 ([link](https://github.com/ameihao/PM566-labs/commit/a1ea5d8986658f8a6f48b390ee16ec456f1ea7fb) to this lab)                                                   |
| [mbolshakova](https://github.com/mbolshakova)     | 2020-09-24 06:39:50 | [mbolshakova](https://github.com/mbolshakova)     | 2nd homework attempt \#25 ([link](https://github.com/mbolshakova/PM566-Homework/commit/46418c081490990b95db519c706376d0768dcc14) to this NA)                                       |
| [asuasu95](https://github.com/asuasu95)           | 2020-09-24 06:43:15 | [asuasu95](https://github.com/asuasu95)           | hw2 \#25 ([link](https://github.com/asuasu95/pm566-homeworks/commit/f6b62c215acc48e6ae8b6f2b72f01b7c3c661482) to this homework)                                                    |
| [Icygrey](https://github.com/Icygrey)             | 2020-09-24 06:54:34 | [Icygrey](https://github.com/Icygrey)             | hw2 ([link](https://github.com/Icygrey/PM566/commit/e995f2eec038f26804b4d13667c5cacd20e500ab) to this homework)                                                                    |
| [jiqingwu1997](https://github.com/jiqingwu1997)   | 2020-09-24 07:19:04 | [jiqingwu1997](https://github.com/jiqingwu1997)   | This is my lab6 \#25 ([link](https://github.com/jiqingwu1997/PM566L/commit/9f7b42c7559132a523c398eac101ce62129410b9) to this lab)                                                  |
| [asuasu95](https://github.com/asuasu95)           | 2020-09-24 07:28:41 | [asuasu95](https://github.com/asuasu95)           | Lab6 \#25 ([link](https://github.com/asuasu95/pm566-labs/commit/b6055d7490c166eb3e59ab19d6e06498539b9bae) to this lab)                                                             |
| [asuasu95](https://github.com/asuasu95)           | 2020-09-24 07:35:34 | [asuasu95](https://github.com/asuasu95)           | Updated Lab6 \#25 ([link](https://github.com/asuasu95/pm566-labs/commit/d56971e19356b009fe0f5c72493ffd34aa398452) to this lab)                                                     |
| [shiyushen](https://github.com/shiyushen)         | 2020-09-24 09:07:44 | [shiyushen](https://github.com/shiyushen)         | lab06 \#25 ([link](https://github.com/shiyushen/PM566-labs/commit/a82ccb2dcbb099cc1697009ebf529a496c035aed) to this lab)                                                           |
| [jiaheche](https://github.com/jiaheche)           | 2020-09-24 15:13:30 | [jiaheche](https://github.com/jiaheche)           | Assignment2 adding git output \#25 ([link](https://github.com/jiaheche/pm566-projects/commit/1a72aea6ffb41f63440c37b484f514b13b43b444) to this homework)                           |
| [cbegay89](https://github.com/cbegay89)           | 2020-09-24 16:34:53 | [cbegay89](https://github.com/cbegay89)           | Assignment 2 Markdown File ([link](https://github.com/cbegay89/PM566-labs/commit/eb6f6e6e11b9ae784302f1aeffea0bd813be9a43) to this homework)                                       |
| [bcruiz](https://github.com/bcruiz)               | 2020-09-24 16:36:21 | [bcruiz](https://github.com/bcruiz)               | Assignment2 - USCbiostats/PM566\#25 ([link](https://github.com/bcruiz/Assignment2/commit/12022f3e65270919064dcf75ead7ae041280ba42) to this homework)                               |
| [Luqing521](https://github.com/Luqing521)         | 2020-09-24 20:06:16 | [Luqing521](https://github.com/Luqing521)         | Lab06 github document \#25 ([link](https://github.com/Luqing521/PM566_Assignment/commit/74a2d915fc65e26d36ace47bdae1515fe77b885e) to this lab)                                     |
| [Luqing521](https://github.com/Luqing521)         | 2020-09-24 20:08:29 | [Luqing521](https://github.com/Luqing521)         | HW02 github document \#25 ([link](https://github.com/Luqing521/PM566_Assignment/commit/b5e54cd01c4ae99fb2468da6d5d7d383ac2fdd83) to this homework)                                 |
| [ashwathkraj](https://github.com/ashwathkraj)     | 2020-09-25 06:56:20 | [ashwathkraj](https://github.com/ashwathkraj)     | \#25 ([link](https://github.com/ashwathkraj/PM566-hws/commit/5778d6726dcf0d4580aaf996c29b4227dc466f7b) to this NA)                                                                 |
| [ashwathkraj](https://github.com/ashwathkraj)     | 2020-09-25 06:56:20 | [ashwathkraj](https://github.com/ashwathkraj)     | \#25 ([link](https://github.com/ashwathkraj/PM566-hws/commit/a00821cf11ce6a1ee01c51c10fc81884c975feba) to this NA)                                                                 |
| [svannord](https://github.com/svannord)           | 2020-09-28 15:19:10 | [svannord](https://github.com/svannord)           | Add files via upload \#25 ([link](https://github.com/svannord/PM566_Lab6/commit/a30ff1dadb76d39f72d6c7e19387639619bedf32) to this NA)                                              |
| [svannord](https://github.com/svannord)           | 2020-09-28 15:20:31 | [svannord](https://github.com/svannord)           | \#25 ([link](https://github.com/svannord/PM566_Lab6/commit/14abdcca42b74346e1b14a1ab6fab2509981bd9b) to this NA)                                                                   |
| [lysethan](https://github.com/lysethan)           | 2020-09-29 08:04:59 | [lysethan](https://github.com/lysethan)           | finalizing pm566 lab-06 \#25 ([link](https://github.com/lysethan/pm566-lab6/commit/033c0eda3c25d443ffd5c77b81adc7f9bd9fac4b) to this lab)                                          |
