import { HttpService } from '../../services/HttpService'
import { Banner } from '../../types/Banner'
import promptAction from '@ohos.promptAction';
import { NavigationMenu } from '../../types/NavigationMenu';
import { Product } from '../../types/Product';
import { Category } from '../../types/Category';
import { RECOMMEND_PAGE_SIZE } from '../../config/constants';
import { GuessYouLike } from '../../components/GuessYouLke'

@Entry
@Component
export default struct Home {
  @State banners: Banner[] = [];
  @State isLoadingBanners: boolean = false;
  @State isLoadBannersFailed: boolean = false;
  @State navigationMenus: NavigationMenu[] = [];
  @State premiumProducts: Product[] = [];
  @State categories: Category[] = [];
  @State recommendedProducts: Product[] = [];
  @State page: number = 1; // 当前页码
  @State hasMoreRecommendedProducts: boolean = true; // 是否有更多的猜你喜欢的数据
  @State loadingMoreProducts: boolean = false; // 是否正在加载下一页猜你喜欢的数据

  aboutToAppear() {
    this.fetchBanners();
    this.fetchNavigationMenus();
    this.fetchPremiumProducts();
    this.fetchCategories();
    this.fetchRecommendedProducts();
  }

  loadMoreProducts = async () => {
    // 若后面还有更多的数据，并且当前没有处于加载下一页的状态，则发请求下一页的数据
    if (this.hasMoreRecommendedProducts && !this.loadingMoreProducts) {
      this.loadingMoreProducts = true;
      this.fetchRecommendedProducts(this.page + 1)
        .then(() => {
          this.page++;
          this.loadingMoreProducts = false;
        })
    }
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

  private async fetchNavigationMenus() {
    const res = await HttpService.get<NavigationMenu[]>('/navigationMenus');
    if (res.success) {
      this.navigationMenus = res.data
    } else {
      console.error('获取 navigationMenus 失败:', res.message);
    }
  }

  private async fetchPremiumProducts() {
    const res = await HttpService.get<Product[]>('/products/premium');
    if (res.success) {
      this.premiumProducts = res.data;
    } else {
      console.error('获取 premiumProducts 失败:', res.message);
    }
  }

  private async fetchCategories() {
    const res = await HttpService.get<Category[]>('/categories/products');
    if (res.success) {
      this.categories = res.data;
    } else {
      console.error('获取 categories 失败:', res.message);
    }
  }

  private async fetchRecommendedProducts(page: number = 1) {
    const res = await HttpService.get<Product[]>(`/products/recommended?page=${page}`);
    if (res.success) {
      const newProducts = res.data;
      if (page === 1) {
        this.recommendedProducts = newProducts;
      } else {
        this.recommendedProducts = [...this.recommendedProducts, ...newProducts];
      }
      // 没有取满一页的数据，则意味着取到底了
      if (!newProducts.length || newProducts.length < RECOMMEND_PAGE_SIZE) {
        this.hasMoreRecommendedProducts = false;
     }
    } else {
      console.error('获取 recommendProducts 失败:', res.message);
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
  buildHomeSwiper() {
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
          .autoPlay(true)
          .width(328)
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
  buildNavigationMenus(){
    Swiper() {
      Grid() {
        ForEach(this.navigationMenus.slice(0, 10), (item: NavigationMenu) => {
          GridItem() {
            Column() {
              Image(item.iconUrl)
                .width(48)
                .height(48)
              Text(item.title)
                .fontSize(12)
            }
            .alignItems(HorizontalAlign.Center)
            .size({ width: '100%', height: '100%' })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')

      Grid() {
        ForEach(this.navigationMenus.slice(10, 20), (item: NavigationMenu) => {
          GridItem() {
            Column() {
              Image(item.iconUrl).width(48).height(48);
              Text(item.title).fontSize(12);
            }
            .alignItems(HorizontalAlign.Center).size({ width: '100%', height: '100%' })
          }
        });
      }.columnsTemplate("1fr 1fr 1fr 1fr 1fr").rowsTemplate('1fr 1fr')
    }
    .width('100%').height(160).margin({ top: 10 }).indicatorStyle({ selectedColor: Color.Gray });
  }

  @Builder
  buildNewcomerBenefits() {
    Row() {
      Image($r('app.media.newcomer_benefits'))
        .width(327)
        .height(170)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .margin({ top: 8 })
  }

  @Builder
  buildPremium() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          if (this.premiumProducts && this.premiumProducts.length) {
            Swiper() {
              ForEach(this.premiumProducts, (item: Product) => {
                this.renderPremiumProduct(item);
              })
            }
            .autoPlay(true).interval(6000)
          }
        }.width('100%').backgroundColor(Color.White).borderRadius(20)

        Text('甄选推荐').fontWeight(FontWeight.Bold).margin({ left: 12, top: 12 })
      }
    }.width('100%').padding({ left: 16, right: 16 }).margin({ top: 8 })
  }

  @Builder
  buildGoodsAreas() {
    ForEach(this.categories, (item: Category) => {
      if (item.products && item.products.length) {
        Column() {
          this.renderAreaTitle(item.name);
          this.renderAreaProducts(item.products);
        }
        .width(328).margin({ top: 8, right: 16, bottom: 8, left: 16 }).borderRadius(16).backgroundColor(Color.White)
      }
    })
  }

  @Builder
  buildGuessYouLke() {
    GuessYouLike({ recommendedProducts: $recommendedProducts });
    if (this.loadingMoreProducts) {
      Row(){
        Image($r('app.media.loading')).width(20).height(20)
        Text('正在加载...').fontSize(14).margin({left: 8})
      }
    } else {
      if (!this.hasMoreRecommendedProducts) {
        Text('没有更多推荐商品了').padding({top: 10, bottom: 10}).textAlign(TextAlign.Center).fontSize(16)
      }
    }
  }

  @Builder
  renderPremiumProduct(product: Product) {
    Column() {
      Image(product.imageUrl).width('100%').height(218).objectFit(ImageFit.ScaleDown)
      Text(product.title).fontWeight(FontWeight.Bold)
      Text(product.subtitle).fontColor(Color.Green)
      Row() {
        Text("¥" + product.price).fontWeight(FontWeight.Bold);
        Button() {
          Text('立即购买').fontWeight(FontWeight.Bold);
        }
        .backgroundColor($r('app.color.primary_background_color'))
        .padding({ top: 8, bottom: 8, left: 8, right: 8 })
      }
      .width('100%').justifyContent(FlexAlign.SpaceBetween)
    }
    .height(324).alignItems(HorizontalAlign.Start).padding({ left: 16, right: 16 })
  }

  @Builder
  renderAreaTitle(name: string) {
    Row() {
      Text(`${name}专区`).fontWeight(FontWeight.Bold).margin({ left: 10 })
      Row() {
        Text('更多')
        Image($r('app.media.right_arrow')).width(17).height(19)
      }.padding({ top: 15, right: 12, bottom: 15, left: 12 })
    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  renderAreaProducts(products: Product[]) {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(products, (product: Product) => {
        Column() {
          Image(product.imageUrl).width(102).height(102)
          Text(product.title).fontSize(14).fontWeight(FontWeight.Bold)
          Text(`¥${product.price}`).fontWeight(FontWeight.Bold)
        }.justifyContent(FlexAlign.Center).width('50%').height(177).justifyContent(FlexAlign.SpaceAround)
      })
    }
  }

  @Builder
  buildHomeContent() {
    Column() {
      // 放置一个滚动的容器
      Scroll() {
        Column() {
          this.buildNavigationBar() // 放置一个导航栏
          this.buildHomeSwiper(); // 在主内容区域嵌入一个轮播图组件
          this.buildNavigationMenus(); // 导航菜单
          this.buildNewcomerBenefits(); // 新人福利专区
          this.buildPremium(); // 甄选推荐
          this.buildGoodsAreas(); // 商品专区
          this.buildGuessYouLke(); // 猜你喜欢
        }
      }
      .edgeEffect(EdgeEffect.None)
      .onScrollEdge(this.loadMoreProducts);
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