Red [ ]


;; Mah-Old-Man-Spellings
;; by c.p.brown 2021
;; site redirect spammer, batch create redirects for site-name misspelling
;; not very useful; special job for special people... leaving it here for reference
;; 32bit linux only
;;
;; usage
;; moms 'yoursite.com'
;;
;; needs
;; ./source.csv
;; ./template_redirect.html
;;
;; outputs
;; ./report.txt
;; ./pub/misspelling1/index.html
;; ./pub/misspelling2/index.html
;; ./pub/misspelling3/index.html
;; ... etc.
;;
;; source.csv
;; propersitename1; misspelling1; misspelling2; misspelling3; etc..
;; propersitename2; misspelling1; misspelling2; misspelling3; etc..
;; ... etc.
;;
;; does not upload, always manually check results

either (length? system/options/args) > 0 [
	site: (trim system/options/args/1)
	either site <> "" [
		template: read %template_redirect.html
		names: read/lines %source.csv
		moms: %report.txt
		write moms "your old-man-mispellings have been delivered to:^/^/"
		foreach x names [
			unless (trim x) = "" [
				cols: split copy x ";"
				unless (length? cols) <= 1 [
					t: trim cols/1
					print [ "correct site name is:" t ]
					unless t = "" [
						remove cols
						repeat n (length? cols) [
							nn: (trim cols/:n)
							unless nn = "" [
								print [ "^-making redirect for:" nn ]
								unless exists? to-file rejoin [ "./pub/" nn "/index.html" ] [ 
									make-dir/deep to-file rejoin [ "./pub/" nn "/" ]
								]
								o: copy template
								replace o "[maholdmanspellings]" rejoin [ t "/index.html" ]
								replace o "[site]" site
								write to-file rejoin [ "./pub/" nn "/index.html"  ] o
								write/append moms rejoin [ "http://www." site "/" nn "/index.html^/" ]
							]
						]
					]
				]
			]
			print [ "^/" ]
		]
		write/append moms "^/all the best, xoxo^/^/-MoMs^/"
	] [ print [ "empty site arg^/usage example: moms 'yoursite.com'^/try again..." ] ]
] [ print [ "missing site arg^/usage example: moms 'yoursite.com'^/try again..." ] ]
