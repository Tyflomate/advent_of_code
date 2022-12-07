# frozen_string_literal: true

require "pry"

class Day07
  def initialize
    @files, @folders, _ = parse_input(File.readlines('./07/input.txt', chomp: true))
  end

  def part1
    calculate_folders_sizes.select { _1 <= 100000 }.sum
  end

  def part2
    space_to_delete = 30_000_000 - (70_000_000 - @files.values.sum)
    calculate_folders_sizes.select{_1 >= space_to_delete}.min
  end

  private

  def parse_input(input)
    input.reduce([{}, Set.new([]), []]) do |file_system, line|
      (files, folders, current_path) = file_system
      first, name, path = line.split(' ')
      if first == '$' && name == 'cd'
        new_path = if path == '/'
                     ['']
                   elsif path == '..'
                     current_path[0...-1]
                   else
                     current_path << path
                   end
        [files, folders.add(new_path.join('/')), new_path]
      elsif first != 'dir' && name != 'ls'
        filename = current_path.join('/') + name
        files[filename] = first.to_i
        [files, folders, current_path]
      else
        file_system
      end
    end
  end

  def calculate_folder_size(folder)
    @files.select { _1.start_with?(folder) }.values.sum
  end

  def calculate_folders_sizes
    @folders.map { calculate_folder_size(_1) }
  end
end
