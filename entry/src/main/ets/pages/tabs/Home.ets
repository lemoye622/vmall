@Entry
@Component
export default struct Home{
  @Builder
  buildHomeHeader() {
    Row(){
      Image($r('app.media.logo'))
        .width(80)
        .height(26)
        .margin({right: 16})
      Search({value: 'Mate60'})
        .width(135)
        .height(40)
        .margin({right: 16})
      Image($r('app.media.messageIcon'))
        .width(24)
        .height(24)
      Text('登陆')
        .margin({left: 16})
        .fontSize(14)
    }
    .width('100%')
    .height(58)
    .padding({left: 16, right: 16})
  }

  @Builder
  buildNavigationBar() {
    Row(){
      Image($r('app.media.nav_bar'))
        .height(44)
    }
    .width('100%')
    .padding({left: 16, right: 16, top: 10})
  }

  @Builder
  buildHomeContent() {
    Column(){
      // 放置一个滚动的容器
      Scroll(){
        Column(){
          this.buildNavigationBar() // 放置一个导航栏
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({top: 58})
  }

  build(){
    // 创建一个Stack布局，并且需要设置内容顶部对齐
    Stack({
      alignContent: Alignment.Top
    }){
      // 构建首页的主内容区域
      this.buildHomeContent();
      this.buildHomeHeader()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.primary_background_color'))
  }
}