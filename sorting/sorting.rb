require 'rubygems'
require 'benchmark/ips'

ARRAY = [15,9,8,1,4,11,7,12,13,16]
BIG = (1..1000).to_a.shuffle

def insertion_sort(arr)
	len = arr.length
	(1..len-1).each do |idx|
		insert(arr, idx, arr[idx])
	end

	return arr
end

def insert(arr, pos, value)
	i = pos - 1
	while i >= 0 and arr[i] > value do
		arr[i+1] = arr[i]
		i = i - 1
    end
    arr[i+1] = value
end

def selection_sort(arr)
	len = arr.length
	(len-1).downto(1) do |idx|
		max_pos = select(arr, idx)
        arr[max_pos], arr[idx] = arr[idx], arr[max_pos]
	end

    return arr
end

def select(arr, pos)
	max_pos = 0
	(1..pos).each do |idx|
		max_pos = idx if arr[idx] > arr[max_pos]
	end
    return max_pos
end

def heap_sort(arr)
	build_heap(arr)
	(arr.length-1).downto(1)  do |idx|
		arr[0],arr[idx]=arr[idx],arr[0]
		heapify(arr,0,idx)
	end

	return arr
 end

def build_heap(arr)
	(arr.length/2-1).downto(0) do |idx|
		heapify(arr,idx, arr.length)
	end
end

def heapify(arr,pos,max)
	largest = pos
    left = 2*pos+1
    right = 2*pos+2

    largest = left if left < max and arr[left] > arr[pos]
    largest = right if right < max and arr[right] > arr[largest] 

    if largest != pos 
    	arr[pos], arr[largest] = arr[largest], arr[pos]
    	heapify(arr, largest, max)
    end
end

def quick_sort(arr)
	len = arr.length
	return arr if len < 2
    
    pivot = arr[len/2-1]
    less = arr[1..len].reduce([]) {|res, el| el < pivot ? res.push(el) : res }
    greater = arr[1..len] - less

    quick_sort(less) + [pivot] + quick_sort(greater)
end

Benchmark.ips do |b|
  b.config(:time => 3, :warmup => 2)
  b.report "insertion_sort" do |times|
    i = 0
    while i < times
      insertion_sort(ARRAY)
      i += 1
    end
  end

  b.report "selection_sort" do |times|
    i = 0
    while i < times
      selection_sort(ARRAY)
      i += 1
    end
  end  
  

  b.report "heap_sort" do |times|
    i = 0
    while i < times
      heap_sort(ARRAY)
      i += 1
    end
  end


  b.report "quick_sort" do |times|
    i = 0
    while i < times
      quick_sort(ARRAY)
      i += 1
    end
  end

  b.report "insertion_sort_big" do |times|
    i = 0
    while i < times
      insertion_sort(BIG)
      i += 1
    end
  end

  b.report "selection_sort_big" do |times|
    i = 0
    while i < times
      selection_sort(BIG)
      i += 1
    end
  end  
  

  b.report "heap_sort_big" do |times|
    i = 0
    while i < times
      heap_sort(BIG)
      i += 1
    end
  end

  b.report "quick_sort_big" do |times|
    i = 0
    while i < times
      quick_sort(BIG)
      i += 1
    end
  end

  b.report "quick_sort_best_case" do |times|
    i = 0
    while i < times
      quick_sort([1,2,3,4,5,6,7,8,9,10])
      i += 1
    end
  end

  b.compare!
end