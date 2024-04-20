import { tabs } from '../config/tabs'
import { Tab } from '../types/Tab'
import Activity from './tabs/Activity'
import Cart from './tabs/Cart'
import Category from './tabs/Category'
import Home from './tabs/Home'
import Personal from './tabs/Personal'

@Entry
@Component
struct Index {
  tabsController: TabsController = new TabsController();
  @State selectedTabIndex: number = 0;
  @Builder
  buildTab(tab: Tab, index: number) {
    Column(){
      Image(index === this.selectedTabIndex ? tab.selectedIcon : tab.icon)
        .width(24)
        .height(24)
      Text(tab.title)
        .fontSize(10)
        .fontColor(index === this.selectedTabIndex ? '#CF0A2C' : Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.primary_background_color'))
    .onClick(() => this.tabIndexChange(index))
  }

  tabIndexChange(index: number) {
    this.selectedTabIndex = index;
    // 通知tabs控制器改变索引对应的页签的内容
    this.tabsController.changeIndex(index);
  }

  build() {
    Column(){
      Tabs({ // 创建tabs容器的时候
        barPosition: BarPosition.End, // 指定bar的位置
        controller: this.tabsController, // 指定使用哪个控制器
        index: this.selectedTabIndex // 当前选中的索引
      }){
        ForEach(tabs, (tab: Tab, index: number) => {
          TabContent(){
            if (index === 0) {
              Home()
            } else if (index === 1) {
              Category()
            } else if (index === 2) {
              Activity()
            } else if (index === 3) {
              Cart()
            } else if (index === 4) {
              Personal()
            }
          }
          .tabBar(this.buildTab(tab, index))
        })
      }
      .animationDuration(0) // 设置切换tab的时候动画持续时间为0
    }
    .width('100%')
    .height('100%')
  }
}