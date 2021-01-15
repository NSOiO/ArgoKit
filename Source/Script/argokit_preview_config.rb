
#Usage:
# 将下面的代码拷贝到Podfile中即可
#post_integrate do |installer|
#    installer.generated_pod_targets.each do |target|
#      if target.name == "ArgoKitPreview"
#        pod_dir = target.sandbox.pod_dir(target.name)
#        require "#{pod_dir}/Source/Script/argokit_preview_config.rb"
#        config_preview_files installer,target
#      end
#    end
#end

require "xcodeproj"
require "pathname"

class APGConstant
    @@argokit_prefix = "[ArgoKitPreview]"
    @@ap_group = 'ArgoKitPreviewFiles'
    @@ap_files = ["/Source/Preview/ArgoKitPreviewTypes.swift", "/Source/Preview/ArgoKitPreviewConfig.swift"]
    
    def self.argokit_prefix
        @@argokit_prefix
    end
    
    def self.ap_group
        @@ap_group
    end
    
    def self.ap_files
        @@ap_files
    end
end

def config_preview_files(installer, ap_target, remove_if_exist = false)
    config_template_file_if_needed installer, ap_target
    ap_target_name = ap_target.name
    #    should_check_file_exist = !remove_if_exist
    file_paths = Array.new
    project_map = Hash.new # [project, aggpods]
    ap_pod_dir = nil
    should_check_file_exist = !remove_if_exist

    installer.aggregate_targets.each do | target |
        ap_pod = target.pod_targets.select {|item| item.name == ap_target_name }.first
        project = target.user_project
        if ap_pod && project
            ap_pod_dir = ap_pod.sandbox.pod_dir(ap_pod.name)
            ts = project_map[project]
            if ts == nil
                ts = Array.new
            end
            ts << target
            project_map[project] = ts
        end
    end
    
    APGConstant.ap_files.each do | file |
        file_paths << "#{ap_pod_dir}#{file}"
    end
    
    project_map.each do |project, aggs|
        if remove_if_exist
            remove_files_from_project project, file_paths
        end
        add_preview_files project, aggs, file_paths, should_check_file_exist
    end
end

def config_template_file_if_needed(installer, target)
    argokit_prefix = APGConstant.argokit_prefix
    pod_dir = target.sandbox.pod_dir(target.name)
    #执行prepare_command中的脚本。因为ArgoKitPreview通过:path引入，脚本不会自动执行。所以在这里执行一次
    #参考：https://guides.cocoapods.org/syntax/podspec.html#prepare_command
    installer.development_pod_targets.each do |dev_target|
      if dev_target.name == target.name
        `cd #{pod_dir}/Source/Script/ && sh ./config.sh`
        puts "#{argokit_prefix} config template file".green
      end
    end
end

def add_preview_files(project, agg_pods, file_paths, should_check_file_exist)
    argokit_prefix = APGConstant.argokit_prefix
  
    user_targets = Array.new
    agg_pods.each do |agg_pod|
        agg_pod.user_target_uuids.each do |uuid|
            t = project.objects_by_uuid[uuid]
            t ? user_targets << t : nil
        end
    end
    
    if user_targets.length == 0
      puts "#{argokit_prefix} Can't find user targets".red
      return
    end
    
    group = project.main_group.find_subpath(File.join(APGConstant.ap_group), true)
      
    file_paths.each do |file_path|
        file_name = File.basename(file_path)
        file_exist = false
        if should_check_file_exist
            group.children.each do |child|
                if child.name == file_name
                  file_exist = true
                  puts "#{argokit_prefix} file #{file_name} exist, only add to target.".green
                  add_file_reference_to_targets(child, user_targets)
                end
            end# group.children
        end# should_check_file_exist
        
        if !file_exist
            rp = Pathname.new(file_path).relative_path_from(Pathname.new(group.real_path))
            if rp
                file_ref = group.new_reference(rp, :group)
            else
                file_ref = group.new_reference(file_path, :absolute)
            end
            add_file_reference_to_targets(file_ref, user_targets)
#            user_targets.each do |target|
#              ret = target.add_file_references([file_ref])
#              if ret.length > 0
#                  puts "#{argokit_prefix} succ to add  #{file_name} to target #{target.name}".green
#              else
#                  puts "#{argokit_prefix} failed to add  #{file_name} to target #{target.name}".red
#              end
#            end
        end# !file_exist
    end
    project.save
end

def add_file_reference_to_targets(file_ref, targets)
    argokit_prefix = APGConstant.argokit_prefix
    targets.each do |target|
      ret = target.add_file_references([file_ref])
      if ret.length > 0
          puts "#{argokit_prefix} succ to add  #{file_ref.name} to target #{target.name}".green
      else
          puts "#{argokit_prefix} failed to add  #{file_ref.name} to target #{target.name}".red
      end
    end
end

def remove_files_from_project(project, file_paths)
    argokit_prefix = APGConstant.argokit_prefix
    
    group = project.main_group.find_subpath(File.join(APGConstant.ap_group), false)
    group.children.each do |child|
        if file_paths.select {|path| File.basename(path) == child.name }
            child.remove_from_project()
            #project.root_object.name
            puts "#{argokit_prefix} file #{child.name} exist, remove from #{File.basename(project.path)}".green
        end
    end
end

class String
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    
    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_brown;       "\e[43m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
    
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def blink;          "\e[5m#{self}\e[25m" end
    def reverse_color;  "\e[7m#{self}\e[27m" end
end


#def integrate_argokit_preview(installer, main_project ,main_target, remove_if_exist = true, ap_target = "ArgoKitPreview")
#    argokit_prefix = "[ArgoKitPreview]"
#    puts "#{argokit_prefix} Start Integrating ArgoKitPreview"
#
#    ap_files = ["/Source/Preview/ArgoKitPreviewTypes.swift"]
#    ap_group = 'ArgoKitPreviewFiles'
#
#    #  ap_group = 'ArgoKitPreview'
#
#    file_paths = Array.new
#    installer.generated_pod_targets.each do |target|
#        if target.name == ap_target
#            pod_dir = target.sandbox.pod_dir(target.name)
#            ap_files.each do |file|
#                file_paths <<  "#{pod_dir}/Source/Preview/ArgoKitPreviewTypes.swift"
#            end
#        end
#    end
#
#    if file_paths.length <= 0
#        puts "#{argokit_prefix} There's nothing to deal with.".red
#        return
#    end
#
#    project_path = Dir.pwd + "/#{main_project}.xcodeproj"
#    # puts project_path
#
#    project = Xcodeproj::Project.open(project_path)
#    project.targets.each do |target|
#        if target.name == main_target
#            # puts target.name
#            group = project.main_group.find_subpath(File.join(ap_group), true)
#            file_paths.each do |file_path|
#                file_name = File.basename(file_path)
#                file_exist = false
#
#                group.children.each do |child|
#                    if child.name == file_name
#                        if remove_if_exist
#                            child.remove_from_project()
#                            puts "#{argokit_prefix} file #{file_name} exist, remove from project.".green
#                        else
#                            file_exist = true
#                            puts "#{argokit_prefix} file #{file_name} exist, no longer need to add.".green
#                        end
#                        break
#                    end
#                end
#
#                if !file_exist
#                    file_ref = group.new_reference(file_path, :absolute)
#                    ret = target.add_file_references([file_ref])
#                    if ret
#                        puts "#{argokit_prefix} succ to add  #{file_name} to #{ap_group}".green
#                    else
#                        puts "#{argokit_prefix} failed to add  #{file_name}".red
#                    end
#                end# !file_exist
#            end# file_paths.each
#        end# if target.name
#    end# project.targets.each
#
#    project.save
#    puts "#{argokit_prefix} End Integrating ArgoKitPreview"
#end

