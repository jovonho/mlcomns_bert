for batch in {0..19}
do
  for n in {0..24}
  do
  	echo -e "batch: $batch"
	echo -e "n: $n"
    part_num=$(( 25 * $batch + $n ))
	echo $part_num
	part_num=$( printf "%05d" $part_num )
	echo -e "Preprocessing part-$part_num"
  done
done	
