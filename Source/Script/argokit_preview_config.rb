require "xcodeproj"

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

def integrate_argokit_preview(installer, main_project ,main_target, remove_if_exist = true, ap_target = "ArgoKitPreview")
    argokit_prefix = "[ArgoKitPreview]"
    puts "#{argokit_prefix} Start Integrating ArgoKitPreview"
    
    ap_files = ["/Source/Preview/ArgoKitPreviewTypes.swift"]
    ap_group = 'ArgoKitPreviewFiles'
    
    #  ap_group = 'ArgoKitPreview'
        
    file_paths = Array.new
    installer.generated_pod_targets.each do |target|
    if target.name == ap_target
        pod_dir = target.sandbox.pod_dir(target.name)
        ap_files.each do |file|
        file_paths <<  "#{pod_dir}/Source/Preview/ArgoKitPreviewTypes.swift"
        end
    end
    end

    if file_paths.length <= 0
        puts "#{argokit_prefix} There's nothing to deal with.".red
        return
    end

    project_path = Dir.pwd + "/#{main_project}.xcodeproj"
    # puts project_path

    project = Xcodeproj::Project.open(project_path)
    project.targets.each do |target|
    if target.name == main_target
        # puts target.name

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
                break
            end
        end

        if !file_exist
            file_ref = group.new_reference(file_path, :absolute)
            ret = target.add_file_references([file_ref])
            if ret
            puts "#{argokit_prefix} succ to add  #{file_name} to #{ap_group}".green
            else
            puts "#{argokit_prefix} failed to add  #{file_name}".red
            end
        end# !file_exist

        end
    end
    end
    project.save
    puts "#{argokit_prefix} End Integrating ArgoKitPreview"
end 


#Usage:
# 需要将main_project和main_target替换成真实数据
#post_integrate do |installer|
#    main_project = '*******'
#    main_target = "*******"
#
#    installer.generated_pod_targets.each do |target|
#      if target.name == "ArgoKitPreview"
#        pod_dir = target.sandbox.pod_dir(target.name)
#        file_path = "#{pod_dir}/Source/Script/argokit_preview_config.rb"
#        require file_path
#        integrate_argokit_preview installer, main_project, main_target
#      end
#    end
#end
