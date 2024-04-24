import { HttpService } from '../../services/HttpService'
import { Banner } from '../../types/Banner'
import promptAction from '@ohos.promptAction';

@Entry
@Component
export default struct Home {
  @State banners: Banner[] = [];
  @State isLoadingBanners: boolean = false;
  @State isLoadBannersFailed: boolean = false;

  aboutToAppear() {
    this.fetchBanners()
  }

  private async fetchBanners() {
    this.isLoadingBanners = true;
    this.isLoadBannersFailed = false;
    try {
      const res = await HttpService.get<Banner[]>('/banners');
      if (res.success) {
        this.banners = res.data;
      } else {
        console.log('获取banners失败', res.message);
        this.isLoadBannersFailed = true;
      }
    } catch (error) {
      promptAction.showToast({
        message: error.message,
        duration: 3000
      });
      this.isLoadBannersFailed = true;
    } finally {
      this.isLoadingBanners = false;
    }
  }

  @Builder
  buildHomeHeader() {
    Row() {
      Image($r('app.media.logo'))
        .width(80)
        .height(26)
        .margin({ right: 16 })
      Search({ value: 'Mate60' })
        .width(135)
        .height(40)
        .margin({ right: 16 })
      Image($r('app.media.messageIcon'))
        .width(24)
        .height(24)
      Text('登陆')
        .margin({ left: 16 })
        .fontSize(14)
    }
    .width('100%')
    .height(58)
    .padding({ left: 16, right: 16 })
  }

  @Builder
  buildNavigationBar() {
    Row() {
      Image($r('app.media.nav_bar'))
        .height(44)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10 })
  }

  @Builder
  buildSwiper() {
    Row() {
      if (this.isLoadingBanners) {
        Image($r('app.media.loading'))
          .width(20)
          .height(20)
      } else if (this.isLoadBannersFailed) {
        Text('加载失败，点击重试')
          .onClick(() => this.fetchBanners())
      } else {
        if (this.banners && this.banners.length) {
          Swiper() {
            ForEach(this.banners, (item: Banner) => {
              Image(item.imageUrl)
            })
          }
          .width(320)
          .borderRadius(20)
          .indicatorStyle({ selectedColor: Color.Gray })
        }
      }
    }
    .width('100%')
    .height(160)
    .margin({ top: 10 })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildHomeContent() {
    Column() {
      // 放置一个滚动的容器
      Scroll() {
        Column() {
          this.buildNavigationBar() // 放置一个导航栏
          this.buildSwiper(); // 在主内容区域嵌入一个轮播图组件
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: 58 })
  }

  build() {
    // 创建一个Stack布局，并且需要设置内容顶部对齐
    Stack({
      alignContent: Alignment.Top
    }) {
      // 构建首页的主内容区域
      this.buildHomeContent();
      this.buildHomeHeader()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.primary_background_color'))
  }
}