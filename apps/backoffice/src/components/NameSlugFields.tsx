"use client";

import { useState } from "react";
import { Field, Input } from "./ui";

/** « Vérités légères » → « verites-legeres ». */
export function slugify(text: string): string {
  return text
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/** Nom + slug. En création, le slug suit le nom tant qu'il n'a pas été
 * modifié à la main ; en édition, il ne bouge pas tout seul (changer un
 * slug existant casse les liens et les imports qui s'y réfèrent). */
export function NameSlugFields({ name, slug, onNameChange, placeholder = "mon-slug", hint = "Minuscules, chiffres et tirets." }: {
  name?: string;
  slug?: string;
  onNameChange?: (v: string) => void;
  placeholder?: string;
  hint?: string;
}) {
  const [nameValue, setName] = useState(name ?? "");
  const [slugValue, setSlug] = useState(slug ?? "");
  const [touched, setTouched] = useState(!!slug);

  return (
    <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
      <Field label="Nom">
        <Input
          name="name"
          value={nameValue}
          required
          maxLength={120}
          onChange={(e) => {
            setName(e.target.value);
            onNameChange?.(e.target.value);
            if (!touched) setSlug(slugify(e.target.value));
          }}
        />
      </Field>
      <Field label="Slug" hint={touched ? hint : `${hint} Généré depuis le nom.`}>
        <Input
          name="slug"
          value={slugValue}
          required
          pattern="[a-z0-9-]+"
          placeholder={placeholder}
          className="font-mono text-[12.5px]"
          onChange={(e) => { setSlug(e.target.value); setTouched(true); }}
        />
      </Field>
    </div>
  );
}
