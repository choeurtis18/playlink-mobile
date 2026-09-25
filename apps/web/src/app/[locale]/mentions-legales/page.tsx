import { LegalPageView, legalMetadata } from "@/components/LegalPageView";

type Props = { params: Promise<{ locale: string }> };

export const generateMetadata = ({ params }: Props) => legalMetadata("legal", params);

export default function Page({ params }: Props) {
  return <LegalPageView legalKey="legal" params={params} />;
}
