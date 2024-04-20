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

  build(){
    Stack({
      alignContent: Alignment.Top
    }){
      this.buildHomeHeader()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.primary_background_color'))
  }
}