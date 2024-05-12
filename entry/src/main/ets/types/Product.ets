export interface Product {
  id: string;
  title: string;
  subtitle?: string;
  category: string;
  price: number;
  crossedOutPrice?: number;
  imageUrl?: string;
  details?: string;
  isNew: boolean;
  isRecommended: boolean;
  isPremium: boolean;
  sortOrder: number;
  isActive: boolean;
}