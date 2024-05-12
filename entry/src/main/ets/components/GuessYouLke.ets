import { Product } from '../types/Product'

@Component
export struct GuessYouLike {
  @Link recommendedProducts: Product[];

  @Builder
  renderGuessYouLikeProduct(product: Product, index: number) {
    Column() {
      Image(product.imageUrl).width(160).height(160)
      Text(product.title).fontSize(14).margin({ top: 5, left: 10 })
      Text(product.subtitle).fontSize(12).fontColor(Color.Gray).margin({ top: 5, left: 10 })
      Text(`¥${product.price}`).fontWeight(FontWeight.Bold).margin({ top: 5, left: 10 })
    }
    .width(160)
    .height(271)
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ bottom: 8, left: index % 2 ? 8 : 0 })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column(){
      Text('猜你喜欢').fontWeight(FontWeight.Bold).padding({ top: 8, right: 16, bottom: 8, left: 16 })
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.recommendedProducts, (product: Product, index: number) => {
          this.renderGuessYouLikeProduct(product, index);
        })
      }.padding({ left: 16, right: 16 })
    }.alignItems(HorizontalAlign.Start)
  }
}