
var sections = [];

function fillSections(listview,sectionProperty) {
//    console.debug("filling Sections", listView, listView.model)
    sections = [];
    if(!listview || !listview.model) {
        return;
    }
    var count = listview.model.count;

    var currentSection = "";
    var currentItem;
    for(var i = 0; i < count; i++) {
        currentItem = listview.model.get(i);
        if(currentItem[sectionProperty] !== currentSection ) {
            currentSection = currentItem[sectionProperty];
//            console.debug(currentSection)
            sections.push({index: i, value: currentSection});
        }
    }
}


function getSectionNameAtRelativePos(position) {
    var index = Math.ceil(((sections.length)*position)/100);
//    console.debug(sections[index-1])
    return sections[index-1];
}

