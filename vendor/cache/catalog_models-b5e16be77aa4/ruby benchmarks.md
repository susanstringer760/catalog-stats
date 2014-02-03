
## loads

### 1.8.7-p352

	./bin/finder project 1
	real	0m2.333s
	user	0m2.217s
	sys	0m0.099s
	real	0m2.272s
	user	0m2.157s
	sys	0m0.097s
	real	0m2.301s
	user	0m2.184s
	sys	0m0.099s

### UNPATCHED 1.9.2

	./bin/finder project 1
	real	0m4.222s
	user	0m3.985s
	sys	0m0.225s
	real	0m4.314s
	user	0m4.083s
	sys	0m0.220s
	real	0m4.234s
	user	0m4.000s
	sys	0m0.223s

### PATCHED 1.9.2-p290

	./bin/finder project 1
	real	0m4.156s
	user	0m3.928s
	sys	0m0.220s
	real	0m4.114s
	user	0m3.889s
	sys	0m0.214s
	real	0m4.116s
	user	0m3.886s
	sys	0m0.217s

### 1.9.3-p0

	./bin/finder project 1
	real	0m1.008s
	user	0m0.644s
	sys	0m0.099s
	real	0m0.669s
	user	0m0.606s
	sys	0m0.048s
	real	0m0.666s
	user	0m0.601s
	sys	0m0.049s

## file-table queries

### 1.8.7

	Using /Users/molecule/.rvm/gems/ruby-1.8.7-p352
	./bin/finder datafile
	
	real	5m35.991s
	user	5m28.712s
	sys	0m1.934s
	./bin/finder datafile
	
	real	5m29.740s
	user	5m25.080s
	sys	0m1.683s
	./bin/finder datafile
	
	real	5m27.379s
	user	5m22.636s
	sys	0m1.696s

### PATCHED 1.9.2-p290
	./bin/finder datafile
	real	8m31.446s
	user	6m49.515s
	sys	0m26.429s
	
	real	8m12.519s
	user	6m46.453s
	sys	0m21.555s
	
	real	8m20.431s
	user	6m46.950s

### 1.9.3-p0

	./bin/finder datafile
	
	real	9m26.306s
	user	6m56.831s
	sys	0m29.530s
	
	real	8m19.686s
	user	6m56.278s
	sys	0m20.134s
	
	real	8m25.389s
	user	6m56.207s
	sys	0m21.042s
