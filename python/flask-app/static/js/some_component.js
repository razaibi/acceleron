//Action Bindings
import common from './common.js';

document.getElementById('btn-something-close').addEventListener("click", function(){
    hide_taskbar();
});

document.getElementById('btn-something-cancel').addEventListener("click", function(){
    hide_taskbar();
});

document.getElementById('btn-something').addEventListener("click", function(){
    show_taskbar();
    document.getElementById('reference_templates_container').innerHTML = get_reference_templates();
});

window.addEventListener("load", function(){
    
});

//Actions
function hide_taskbar(){
    document.getElementById('taskbar').style.display='none';
}

function show_taskbar(){
    document.getElementById('taskbar').style.display='block';
}


function get_reference_templates(search_string){
    var temp_data = [
        {
            'id': '123123123',
            'label': 'Something Sample',
            'name': 'Sample Name'
        }
    ];
    var html = common.render_list('reference_templates_list_item', temp_data);
    return html;
}

