
#Usage:
# 将下面的代码拷贝到Podfile中即可
#post_integrate do |installer|
#    installer.generated_pod_targets.each do |target|
#      if target.name == "ArgoKitPreview"
#        pod_dir = target.sandbox.pod_dir(target.name)
#        require "#{pod_dir}/Source/Script/argokit_preview_config.rb"
#        config_preview_files installer
#      end
#    end
#end

require "xcodeproj"

def config_preview_files(installer, remove_if_exist = false, ap_target_name = "ArgoKitPreview")
  ap_files = ["/Source/Preview/ArgoKitPreviewTypes.swift"]
  file_paths = Array.new
  
  installer.aggregate_targets.each do | target |
    ap_pod = target.pod_targets.select {|item| item.name == ap_target_name }.first
    if ap_pod
      ap_pod_dir = ap_pod.sandbox.pod_dir(ap_pod.name)
      ap_files.each do | file |
        file_paths << "#{ap_pod_dir}#{file}"
      end
      add_preview_files target, ap_pod, file_paths, remove_if_exist
    end
  end
end

def add_preview_files(agg_pod, ap_pod, file_paths, remove_if_exist)
  ap_group = 'ArgoKitPreviewFiles'
  argokit_prefix = "[ArgoKitPreview]"
  project = agg_pod.user_project
  
  user_targets = Array.new
  agg_pod.user_target_uuids.each do |uuid|
    t = project.objects_by_uuid[uuid]
    t ? user_targets << t : nil
  end
  
  if user_targets.length == 0
    puts "#{argokit_prefix} Can't find user targets".red
    return
  end
  
  group = project.main_group.find_subpath(File.join(ap_group), true)
  
  file_paths.each do |file_path|
      file_name = File.basename(file_path)
      file_exist = false
      group.children.each do |child|
          if child.name == file_name
              if remove_if_exist
                  child.remove_from_project()
                  puts "#{argokit_prefix} file #{file_name} exist, remove from project.".green
              else
                  file_exist = true
                  puts "#{argokit_prefix} file #{file_name} exist, no longer need to add.".green
              end
          end
      end# group.children
      
      if !file_exist
          file_ref = group.new_reference(file_path, :absolute)
          user_targets.each do |target|
            ret = target.add_file_references([file_ref])
            if ret
                puts "#{argokit_prefix} succ to add  #{file_name} to target #{target.name}".green
            else
                puts "#{argokit_prefix} failed to add  #{file_name} to target #{target.name}".red
            end
          end
      end# !file_exist
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

