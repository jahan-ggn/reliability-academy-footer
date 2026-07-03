import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { trustHTML } from "@ember/template";
import { eq } from "discourse/truth-helpers";

export default class ReliabilityFooter extends Component {
  @tracked _socialIcons = {};

  get navLinks() {
    return (settings.nav_links || []).map((link) => ({
      ...link,
    }));
  }

  get socialLinks() {
    return (settings.social_links || []).map((link) => ({
      ...link,
      svg: this._socialIcons[link.url] || null,
    }));
  }

  get hasBackgroundImage() {
    return settings.background_image && settings.background_image.length > 0;
  }

  get footerStyle() {
    if (this.hasBackgroundImage) {
      return trustHTML(`background-image: url("${settings.background_image}")`);
    }
    return null;
  }

  get contactEmailHref() {
    return `mailto:${settings.contact_email}`;
  }

  @action
  async _loadSocialIcons() {
    const links = settings.social_links || [];
    const results = {};

    await Promise.all(
      links.map(async (link) => {
        try {
          const response = await fetch(link.icon);
          const svg = await response.text();
          results[link.url] = svg;
        } catch {
          results[link.url] = null;
        }
      })
    );

    this._socialIcons = results;
  }

  <template>
    {{#if @showFooter}}
      <footer
        class="ra-footer {{if this.hasBackgroundImage 'ra-footer--has-bg'}}"
        style={{this.footerStyle}}
        {{didInsert this._loadSocialIcons}}
      >
        <div class="ra-footer__container">
          <div class="ra-footer__left">
            {{#if settings.logo}}
              <a class="ra-footer__logo-link" href={{settings.logo_link}}>
                <img
                  class="ra-footer__logo"
                  src={{settings.logo}}
                  alt="R2 Reliability"
                  loading="lazy"
                />
              </a>
            {{/if}}

            {{#if this.navLinks.length}}
              <ul class="ra-footer__nav">
                {{#each this.navLinks as |link|}}
                  <li class="ra-footer__nav-item">
                    <a
                      href={{link.url}}
                      class="ra-footer__nav-link"
                    >{{link.text}}</a>
                  </li>
                {{/each}}
              </ul>
            {{/if}}

            {{#if settings.copyright_text}}
              <p class="ra-footer__copyright">{{settings.copyright_text}}</p>
            {{/if}}
          </div>

          <div class="ra-footer__right">
            {{#if this.socialLinks.length}}
              <ul class="ra-footer__social">
                {{#each this.socialLinks as |link|}}
                  <li class="ra-footer__social-item">
                    <a
                      href={{link.url}}
                      target={{link.target}}
                      rel={{if (eq link.target "_blank") "noopener noreferrer"}}
                      class="ra-footer__social-link"
                      aria-label={{link.text}}
                    >
                      {{#if link.svg}}
                        {{trustHTML link.svg}}
                      {{/if}}
                    </a>
                  </li>
                {{/each}}
              </ul>
            {{/if}}

            {{#if settings.contact_email}}
              <p class="ra-footer__contact">
                Contact us at
                <a href={{this.contactEmailHref}}>{{settings.contact_email}}</a>
              </p>
            {{/if}}
          </div>
        </div>
      </footer>
    {{/if}}
  </template>
}
