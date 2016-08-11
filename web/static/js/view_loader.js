import MainView    from './main';
import PageIndexView from './page/index';
import PlaceIndexView from './place/index';
import PlaceEditView from './place/edit'


const views = {
  PageIndexView,
  PlaceIndexView,
  PlaceEditView
}

export default function loadView(viewName) {
  return views[viewName] || MainView;
}