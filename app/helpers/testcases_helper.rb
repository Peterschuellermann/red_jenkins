module TestcasesHelper

    # Parameter map is the (sub-)tree in which we want to add the
    # testcase t which has the remaining path (given in an array).
    # The path_array is supposed to be path.split(".").
    def add(map, path_array, t)
        # If path_array is empty, then the testcase shall be added to the map
        if path_array.length == 0
            test = {}
            test[:name] = t.name
            test[:status] = t.status.downcase
            test[:type] = "method"
            test[:content] = t
            map[t.name] = test
            # If the hash has already a key, then the content of the package is added to the map
        elsif map.has_key?(path_array[0])
            pack = map[path_array[0]]
            pack[:status][t.status.downcase] ||= 0;
            pack[:status][t.status.downcase] += 1;
            add(pack[:content], path_array.drop(1), t)
            # Else the content is added to the map
            # Else add the content to the map
        else
            pack = {}
            pack[:name] = path_array[0]
            if path_array.length >= 2
                pack[:type] = "package"
            else
                pack[:type] = "class"
            end
            pack[:status] = {t.status.downcase => 1}
            pack[:content] = {}
            map[path_array[0]] = pack
            add(pack[:content], path_array.drop(1), t)
        end
    end

end
