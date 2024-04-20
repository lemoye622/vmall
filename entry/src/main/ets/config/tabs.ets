import { Tab } from '../types/Tab'

export const tabs: Tab[] = [
  {
    title: '首页',
    icon: $r('app.media.home_icon'),
    selectedIcon: $r('app.media.home_selected_icon')
  },
  {
    title: '分类',
    icon: $r('app.media.category_icon'),
    selectedIcon: $r('app.media.category_selected_icon')
  },
  {
    title: '发现',
    icon: $r('app.media.discover_icon'),
    selectedIcon: $r('app.media.discover_selected_icon')
  },
  {
    title: '购物车',
    icon: $r('app.media.cart_icon'),
    selectedIcon: $r('app.media.cart_selected_icon')
  },
  {
    title: '我的',
    icon: $r('app.media.user_icon'),
    selectedIcon: $r('app.media.user_selected_icon')
  }
]