#!/usr/bin/env python3
import os
import glob
import json

def fetch_gamemode_apps():
    apps = {}
    home = os.path.expanduser('~')
    
    dirs = [
        '/usr/share/applications',
        '/usr/local/share/applications',
        f'{home}/.local/share/applications',
        '/var/lib/flatpak/exports/share/applications',
        f'{home}/.local/share/flatpak/exports/share/applications',
        f'{home}/.nix-profile/share/applications',
        '/run/current-system/sw/share/applications'
    ]
    
    local_dir = f'{home}/.local/share/applications'

    for d in dirs:
        if not os.path.exists(d):
            continue
            
        for f in glob.glob(os.path.join(d, '**/*.desktop'), recursive=True):
            try:
                basename = os.path.basename(f)
                
                # Verify if we already parsed this exact app name or a local override exists
                # We prioritize the local override for gamemode state
                local_desktop_path = os.path.join(local_dir, basename)
                
                file_to_read = f
                if os.path.exists(local_desktop_path):
                    file_to_read = local_desktop_path

                with open(file_to_read, 'r', encoding='utf-8') as file:
                    app = {'name': '', 'exec': '', 'icon': '', 'desktop': basename, 'sys_path': f, 'gamemode': False}
                    is_desktop = False
                    no_display = False
                    
                    for line in file:
                        line = line.strip()
                        if line == '[Desktop Entry]':
                            is_desktop = True
                        elif line.startswith('['):
                            is_desktop = False
                            
                        if is_desktop:
                            if line.startswith('Name=') and not app['name']:
                                app['name'] = line[5:]
                            elif line.startswith('Exec='):
                                exec_line = line[5:]
                                # Check if it has gamemoderun
                                if exec_line.startswith('gamemoderun '):
                                    app['gamemode'] = True
                                    exec_line = exec_line.replace('gamemoderun ', '', 1)
                                
                                if not app['exec']:
                                    app['exec'] = exec_line.split(' %')[0].split(' @@')[0]
                            elif line.startswith('Icon=') and not app['icon']:
                                app['icon'] = line[5:]
                            elif line.startswith('NoDisplay=true') or line.startswith('NoDisplay=1'):
                                no_display = True
                                
                    if app['name'] and app['exec'] and not no_display:
                        apps[app['name']] = app
            except Exception:
                pass
                
    res = list(apps.values())
    res.sort(key=lambda x: x['name'].lower())
    print(json.dumps(res))

if __name__ == "__main__":
    fetch_gamemode_apps()
