import { Product } from '../../types/Product';
import { RECOMMEND_PAGE_SIZE } from '../../config/constants';
import { GuessYouLike } from '../../components/GuessYouLke'
import { HttpService } from '../../services/HttpService'

@Entry
@Component
export default struct Personal {
  @State isShowNavigator: boolean = false;
  @State recommendedProducts: Product[] = [];
  @State hasMoreRecommendedProducts: boolean = true; // 是否有更多的猜你喜欢的数据
  @State isLoadingMoreProducts: boolean = false; // 是否正在加载下一页猜你喜欢的数据
  @State isLoadRecommendedProductsError: boolean = false;
  @State recommendedProductsErrorMessage: string = "";
  scroller: Scroller = new Scroller(); // 滚动条实例

  aboutToAppear() {
    this.fetchRecommendedProducts();
  }

  fetchRecommendedProducts = async () => {
    // 若当前正在加载中或没有更多数据了，直接返回
    if (this.isLoadingMoreProducts || !this.hasMoreRecommendedProducts) return;
    // 这次的处理方式和之前不一样，此处不单独维护一个当前页码的变量，而是动态根据数据的条数进行计算
    const nextPage = Math.ceil(this.recommendedProducts.length / RECOMMEND_PAGE_SIZE) + 1;
    this.isLoadingMoreProducts = true;
    this.isLoadRecommendedProductsError = false;
    try {
      const res = await HttpService.get<Product[]>(`/products/recommended?page=${nextPage}`);
      if (res.success) {
        const newProducts = res.data;
        this.recommendedProducts = nextPage === 1 ? newProducts : [...this.recommendedProducts, ...newProducts];
        this.hasMoreRecommendedProducts = newProducts.length && newProducts.length >= RECOMMEND_PAGE_SIZE;
      } else {
        this.isLoadRecommendedProductsError = true;
        this.recommendedProductsErrorMessage = '加载失败，请点击重试。';
        console.error('获取 recommendProducts 失败:', res.message);
      }
    } catch (error) {
      this.isLoadRecommendedProductsError = true;
      this.recommendedProductsErrorMessage = error.message || '网络错误，请重试。';
    } finally {
      this.isLoadingMoreProducts = false;
    }
  }

  @Builder
  buildPersonalNavigator() {
    if (this.isShowNavigator) {
      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.navigator_bg')).width('100%').height('100%').objectFit(ImageFit.Cover)
        Row() {
          Row() {
            Image($r('app.media.ic_avatar')).width(32).height(32)
            Text('登录/注册').fontColor(Color.White).fontSize(18).margin({ left: 12 })
          }.margin({ left: 12 })

          Row() {
            Image($r('app.media.icon_settings')).width(24).height(24)
            Image($r('app.media.icon_message')).width(24).height(24).margin({ left: 12 })
          }.margin({ right: 12 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(56)
    }
  }

  @Builder
  buildPersonalHeader() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.header_bg')).width('100%').height(200).objectFit(ImageFit.Cover);
      Column() {
        Row() {
          Image($r('app.media.icon_settings')).width(24).height(24)
          Image($r('app.media.icon_message')).width(24).height(24).margin({ left: 12 })
        }.width(328).padding({ top: 16 }).justifyContent(FlexAlign.End) // 这里的宽度328 是总宽度360 - 两边边距16 * 2
        Row() {
          Image($r('app.media.ic_avatar')).width(48).height(48)
          Text('登录/注册').fontColor(Color.White).fontSize(18).margin({ left: 12 })
        }.width(328)

        Row() {
          Column() {
            Text('--').fontColor(Color.White).fontSize(16)
            Text('积分').fontColor(Color.White).opacity(0.6)
          }

          Column() {
            Text('--').fontColor(Color.White).fontSize(16)
            Text('优惠券').fontColor(Color.White).opacity(0.6)
          }

          Column() {
            Text('--').fontColor(Color.White).fontSize(16)
            Text('代金券').fontColor(Color.White).opacity(0.6)
          }
        }
        .width(328)
        .height(35)
        .padding({ left: 20, right: 20 })
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ top: 12 })
      }
    }
  }

  @Builder
  buildMyOrders() {
    Row() {
      Column() {
        Row() {
          Text('我的订单').fontSize(18).fontWeight(FontWeight.Bold)
          Text('全部订单>').fontSize(14).opacity(.6)
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(12)

        Row() {
          Column() {
            Image($r('app.media.icon_payment')).width(24).height(24)
            Text('待付款').fontSize(14)
          }.alignItems(HorizontalAlign.Center)

          Column() {
            Image($r('app.media.icon_pending')).width(24).height(24);
            Text('待收货').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_review')).width(24).height(24);
            Text('待评价').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_return_refund')).width(24).height(24);
            Text('退换/退款').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_recycle_order')).width(24).height(24);
            Text('回收单').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
        }.width('100%').justifyContent(FlexAlign.SpaceAround).padding(12).margin({ bottom: 12 })
      }.width(328).backgroundColor(Color.White).borderRadius(16)
    }.width('100%').padding({ left: 16, right: 16 })
  }

  @Builder
  buildMyServices() {
    Row() {
      Column() {
        Row() {
          Text('我的服务').fontSize(18).fontWeight(FontWeight.Bold);
          Text('在线咨询').fontSize(14).opacity(0.6);
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(12);
        Row() {
          Column() {
            Image($r('app.media.icon_official_after_sales')).width(24).height(24);
            Text('官方售后').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_contact_customer_service')).width(24).height(24);
            Text('联系客服').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_service_store')).width(24).height(24);
            Text('服务商店').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_value_preservation_renewal')).width(24).height(24);
            Text('保值焕新').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
          Column() {
            Image($r('app.media.icon_request_repair')).width(24).height(24);
            Text('我要维修').fontSize(14);
          }.alignItems(HorizontalAlign.Center);
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding(12)
        .margin({ bottom: 12 });
      }
      .width(328)
      .backgroundColor(Color.White).borderRadius(16);
    }
    .width('100%')
    .padding({ left: 16, right: 16 });
  }

  @Builder
  buildCommonlyUsed() {
    Row() {
      List({ space: 8 }) {
        ListItem() {
          Column() {
            Image($r('app.media.icon_my_points')).width(48).height(48)
            Text('我的积分').fontSize(14)
          }
          .width('20%')
          .padding({ top: 8, bottom: 8 })
          .margin({ left: 12 })
          .alignItems(HorizontalAlign.Center)
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_mall_announcement')).width(48).height(48);
            Text('商城公告').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_feedback')).width(48).height(48);
            Text('体验反馈').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_yougouma')).width(48).height(48);
            Text('优购码').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_membership_channel')).width(48).height(48);
            Text('会员频道').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_education_purchase')).width(48).height(48);
            Text('教育购').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }

        ListItem() {
          Column() {
            Image($r('app.media.icon_huawei_card')).width(48).height(48);
            Text('HWCard').fontSize(14);
          }
          .alignItems(HorizontalAlign.Center)
          .width('20%')
          .padding({ top: 8, bottom: 8 });
        }
      }
      .scrollBar(BarState.Off) // 关闭滚动条
      .edgeEffect(EdgeEffect.None) // 去掉滚动动画效果
      .listDirection(Axis.Horizontal) // 水平方向滚动
      .backgroundColor(Color.White)
      .borderRadius(16)
    }
    .padding({ left: 16, right: 16 })
  }

  @Builder
  buildSignInEarnPoints() {
    Row() {
      Image($r('app.media.icon_sign_in_earn_points'))
        .width('100%')
        .height(81)
        .borderRadius(16)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  @Builder
  buildUserSurvey() {
    Row() {
      Image($r('app.media.icon_user_experience_survey'))
        .width('100%')
        .height(64)
        .borderRadius(16)
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  @Builder
  buildGuessYouLike() {
    GuessYouLike({ recommendedProducts: $recommendedProducts });
    if (this.isLoadingMoreProducts) {
      Row() {
        Image($r('app.media.loading')).width(20).height(20)
        Text('正在加载...').fontSize(14).margin({ left: 8 })
      }
      .padding({ bottom: 10 })
    } else if (this.isLoadRecommendedProductsError) {
      Text(this.recommendedProductsErrorMessage)
        .width('100%')
        .textAlign(TextAlign.Center)
        .onClick(this.fetchRecommendedProducts)
    } else {
      if (!this.hasMoreRecommendedProducts) {
        Text('没有更多推荐商品了').padding({ bottom: 10 }).textAlign(TextAlign.Center).fontSize(16)
      }
    }
  }

  @Builder
  buildPersonalContent() {
    Column() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          this.buildPersonalHeader();
          this.buildMyOrders(); // 我的订单
          this.buildMyServices(); // 我的服务
          this.buildCommonlyUsed(); // 常用功能
          this.buildSignInEarnPoints(); // 签到赚积分
          this.buildUserSurvey(); // 用户体验调研
          this.buildGuessYouLike(); // 猜你喜欢
        }
      }
      .edgeEffect(EdgeEffect.None)
      .onScrollEdge(this.fetchRecommendedProducts)
      .onScroll(() => {
        const { yOffset } = this.scroller.currentOffset();
        this.isShowNavigator = yOffset >= 140;
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      this.buildPersonalContent()
      this.buildPersonalNavigator();
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.primary_background_color'));
  }
}