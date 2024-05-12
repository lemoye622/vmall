import { Product } from "./Product";
export interface Category {
  id?: string;
  name: string;
  imageUrl: string;
  parent?: string;
  sortOrder: number;
  isActive: boolean;
  products?: Product[];
}