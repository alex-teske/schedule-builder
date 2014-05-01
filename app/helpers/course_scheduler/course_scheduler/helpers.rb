

def get_combinations dimensions

  current = Array.new
  for x in 0..dimensions.length-1
    current.push(0)
  end

  combinations = Array.new

  overflow = false
  until overflow
    combinations.push(current.dup)

    (0..current.length - 1).reverse_each do |i|
      current[i] = current[i] + 1

      if current[i] >= dimensions[i]
        current[i] = 0
        if i == 0
          overflow = true
        end
      else
        break
      end

    end
  end

  combinations
end